require 'colorize'
require 'ruby-debug'

module Checkers

PLAYER_NAMES = {:red => "Red Team", :black => "Black Team"}

class CheckersGame

  PLAYER_COLORS = {0 => :red, 1 => :black}

  def initialize
    setup
    play
  end

  def setup
    @board = Checkerboard.new
    @players = [HumanPlayer.new(:red), HumanPlayer.new(:black)]
    @playing = 0
  end

  def play
    until @board.win?(:red) or @board.win?(:black)
      @board.show
      legal_moves = @board.legal_moves(PLAYER_COLORS[@playing])
      move = @players[@playing].get_move(legal_moves)
      @board.make_move(move)
      @board.promotions
      @playing = (@playing + 1) % 2
    end
    @board.show
    winner, loser = @board.win?(:red) ? [:red, :black] : [:black, :red]
    puts "#{PLAYER_NAMES[winner]} wins!! #{PLAYER_NAMES[loser]} is destroyed"
  end

end

class HumanPlayer

  def initialize(color)
    @color = color
  end

  def get_move(legal_moves)
    slides, jumps = legal_moves
    letters = ('A'..'Z').to_a
    letter_to_index = Hash[letters.zip((0..25).to_a)]
    puts "#{PLAYER_NAMES[@color]}, select a move from the list"
    slides.each_with_index do |slide, i|
      puts "#{letters[i]}: #{slide[0]} -> #{slide[1]}"
    end
    jumps.each_with_index do |jump, i|
      jump_string = ""
      (0...jump.length-1).each do |jmp_pos|
        jump_string += "#{jump[jmp_pos]} jmp "
      end
      jump_string += jump[-1].to_s
      puts "#{letters[slides.length+i]}: #{jump_string}"
    end
      #puts "#{letters[i+slides.length]}: #{jump[0]} jmp #{jump[1]}" # TODO representation of jump
    input = gets.chomp
    index = letter_to_index[input.upcase]
    jump = index >= slides.length
    all_moves = legal_moves[0] + legal_moves[1]
    [jump, all_moves[index]]
  end

end

class Checkerboard

  Checker = Struct.new("Checker", :color, :royalty)

  ENEMY = {:red => :black, :black => :red}

  def initialize(blank = false)
    @board = Array.new(8){ Array.new(8) }
    unless blank
      setup_checkers(0, :black)
      setup_checkers(5, :red)
    end
  end

  def setup_checkers(from_row, color)
    (from_row..from_row+2).each do |row|
      (0..7).each do |col|
        if (row + col) % 2 == 1
          @board[row][col] = Checker.new(color, false)
        end
      end
    end
  end

  def at(position)
    @board[position[0]][position[1]]
  end

  def put(position, checker)
    @board[position[0]][position[1]] = checker
  end

  def dup
    duplicate = Checkerboard.new(true)
    (0..7).each do |row|
      (0..7).each do |col|
        position = [row, col]
        checker = at(position)
        if checker
          duplicate.put(position, Checker.new(checker.color, checker.royalty))
        end
      end
    end
    duplicate
  end

  def show
    puts "  0 1 2 3 4 5 6 7"
    (0..7).each do |row|
      print row.to_s + " "
      (0..7).each do |col|
        position = [row, col]
        checker = at(position)
        unless checker.nil?
          if checker.color == :black
            unless checker.royalty
              print "\u2B24 ".colorize(:background => :cyan, :color => :black)
            else
              print "\u265B ".colorize(:background => :cyan, :color => :black)
            end
          elsif at([row, col]).color == :red
            unless checker.royalty
              print "\u2B24 ".colorize(:background => :cyan, :color => :light_red)
            else
              print "\u265B ".colorize(:background => :cyan, :color => :light_red)
            end
          end
        else
          if (row + col) % 2 == 1
            print "  ".colorize(:background => :cyan)
          else
            print "  ".colorize(:background => :white)
          end
        end
      end
      print "\n"
    end
  end

  def Checkerboard.in_bounds?(position)
    (position[0] >= 0) and (position[0] < 8) and (position[1] >= 0) and (position[1] < 8)
  end

  def Checkerboard.slide_destiny(position, offset)
    [position[0] + offset[0], position[1] + offset[1]]
  end

  def Checkerboard.jump_destiny(position, direction)
    Checkerboard.slide_destiny(position, direction.map { |coordinate| 2 * coordinate } )
  end

  def Checkerboard.jumped_square(start, finish)
    offset = [(finish[0]-start[0])/2, (finish[1]-start[1])/2]
    Checkerboard.slide_destiny(start, offset)
  end

  def promotions
    [0, 7].each do |row|
      (0..7).each do |col|
        position = [row, col]
        checker = at(position)
        if at(position)
          if (checker.color == :red) and (row == 0) and (!checker.royalty)
            checker.royalty = true
          elsif (checker.color == :black) and (row == 7) and (!checker.royalty)
            checker.royalty = true
          end
        end
      end
    end
  end

  def checker_moves(position)
    checker = at(position)
    color, royalty = checker.color, checker.royalty
    if royalty
      directions = [[-1, -1], [-1, 1], [1, 1], [1, -1]]
    elsif color == :red
      directions = [[-1, -1], [-1, 1]]
    elsif color == :black
      directions = [[1, -1], [1, 1]]
    end
    directions.select! { |direction| Checkerboard.in_bounds?(Checkerboard.slide_destiny(position, direction)) }

    slides = []
    jumps = []
    directions.each do |direction|
      slide_square = Checkerboard.slide_destiny(position, direction)
      if at(slide_square).nil?
        slides.push(slide_square)
      elsif at(slide_square).color == ENEMY[color]
        jump_square = Checkerboard.jump_destiny(position, direction)
        if Checkerboard.in_bounds?(jump_square) and at(jump_square).nil?
          jumps.push(jump_square)
        end
      end
    end
    [slides, jumps]
  end

  def legal_moves(color)
    slides = []
    jumps = []
    (0..7).each do |row|
      (0..7).each do |col|
        position = [row, col]
        checker = at(position)
        if !checker.nil? and checker.color == color
          slide_candidates, jump_candidates = checker_moves(position)
          slide_candidates.each do |slide|
            slides.push([position, slide])
          end
          jump_candidates.each do |jump|
            jumps.push([position, jump])
          end
        end
      end
    end
    # check for multijumps
    more_jumps_maybe = true
    while more_jumps_maybe
      more_jumps_maybe = false
      previous_jump_record = jumps.map { |jump_seq| jump_seq.length }.max
      previous_record_jumps = jumps.select { |jump_seq| jump_seq.length == previous_jump_record }
      previous_record_jumps.each do |jump_seq|
        next_board = self.dup
        next_board.make_move([true, jump_seq])
        _, multijump_candidates = next_board.checker_moves(jump_seq[-1])
        multijump_candidates.each do |jump|
          jumps.push(jump_seq + [jump])
          more_jumps_maybe = true
        end
      end
    end
    [slides, jumps]
  end

  def make_move(move)
    unless move[0]
      slide(move[1])
    else
      jump(move[1])
    end
  end

  def slide(positions)
    checker = at(positions[0])
    put(positions[1], checker)
    put(positions[0], nil)
  end


  def jump(positions)
    checker = at(positions[0])
    put(positions[-1], checker)
    put(positions[0], nil)
    (0...positions.length-1).each do |jump_index|
      put(Checkerboard.jumped_square(positions[jump_index], positions[jump_index+1]), nil)
    end
  end

  def win?(color)
    enemy_moves = legal_moves(ENEMY[color])
    enemy_moves[0].empty? and enemy_moves[1].empty?
  end

end

end # end Checkers module

if __FILE__ == $PROGRAM_NAME
  Checkers::CheckersGame.new
end
