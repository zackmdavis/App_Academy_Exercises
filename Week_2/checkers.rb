require 'colorize'
require 'ruby-debug'

class CheckersGame

  PLAYER_COLORS = {0 => :red, 1 => :black}

  def initialize
    setup
    play
  end

  def setup
    @board = Checkerboard.new
    @players = [HumanPlayer.new, HumanPlayer.new]
    @playing = 0
  end

  def play
    until @board.win?(:red) or @board.win?(:black)
      @board.show
      legal_moves = @board.legal_moves(PLAYER_COLORS[@playing])
      move = @players[@playing].get_move(legal_moves)
      @board.make_move(move)
      @playing = (@playing + 1) % 2
    end
    @board.show
    winner, loser = @board.win?(:red) ? [:red, :black] : [:black, :red]
    player_names = {:red => "Red Team", :black => "Black Team"}
    puts "#{player_names[winner]} wins!! #{player_names[loser]} is destroyed"
  end

end

class HumanPlayer

  def get_move(legal_moves)
    slides, jumps = legal_moves
    letters = ('A'..'Z').to_a
    letter_to_index = Hash[letters.zip((0..25).to_a)]
    puts "Select a move from the list"
    slides.each_with_index do |slide, i|
      puts "#{letters[i]}: #{slide[0]} -> #{slide[1]}"
    end
    jumps.each_with_index do |jump, i|
      puts "#{letters[i+slides.length]}:" # TODO representation of jump
    end
    input = gets.chomp
    index = letter_to_index[input.upcase]
    jump = index >= slides.length
    [jump, legal_moves[index]]
  end

end

class Checkerboard

  Checker = Struct.new("Checker", :color, :royalty)

  ENEMY = {:red => :black, :black => :red}

  def initialize
    @board = Array.new(8){ Array.new(8) }
    setup_checkers(0, :black)
    setup_checkers(5, :red)
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

  def checker_moves(position)
    checker = at(position)
    color, royalty = checker.color, checker.royalty
    if royalty
      directions = [[-1, -1], [-1, 1], [1, 1], [1, -1]]
    elsif color == :red
      directions = [[-1, -1], [1, -1]]
    elsif color == :black
      directions = [[-1, 1], [1, 1]]
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
          # TODO jumps and n-tuple jumps
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
    set(positions[1], checker)
    set(positions[0], nil)
  end

  def jump(positions)
    # TODO
  end

  def win?(color)
    legal_moves(ENEMY[color]).empty?
  end

end

if __FILE__ == $PROGRAM_NAME
  CheckersGame.new
end
