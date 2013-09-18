require 'ruby-debug'

class Game

  def initialize(human_players = 1)
    # Make board of underscores
    @board = Board.new
    @players = []
    @game_over = false
    @turn = 0
    @marks = { 0 => 'X', 1 => 'O' }

    if human_players == 0
      @players << ComputerPlayer.new('X')
      @players << ComputerPlayer.new('O')
    elsif human_players == 1
      @players << HumanPlayer.new
      @players << ComputerPlayer.new('O')
    else
      @players << HumanPlayer.new
      @players << HumanPlayer.new
    end
  end

  def play
    messages = { :p1win => "Player 1 wins!", :p2win => "Player 2 wins!", :tie => "Draw!"}

    until @game_over
      @board.show
      # take move
      move = @players[@turn].take_move(@board)
      #p "Second one --  #{move}"

      until @board.legal_move?(move)
        puts "That move is not legal; try again!"
        move = @players[@turn].take_move(@board)
      end

      @board.mark(move, @marks[@turn])

      # evaluate board
      endings = [:p1win, :p2win, :tie]
      if endings.include? @board.eval_board
        puts messages[@board.eval_board]
        @game_over = true
        @board.show
      end

      # now it's the other player's turn
      @turn = (@turn + 1) % 2
    end
  end

end

class Board
  attr_accessor :data

  def initialize
    @data = (1..3).map{|_| (1..3).map{|_| '_'}}
  end

  def mark(move, mark)
    @data[move[0]][move[1]] = mark
  end

  def counterfactual_mark(move, mark)
    what_if = Board.new
    temp = []
    @data.each { |row| temp << row.dup}
    what_if.data = temp
    what_if.mark(move,mark)
    what_if
  end

  def show
    @data.each do |row|
      row.each do |mark|
        print mark, ' '
      end
      print "\n"
    end
  end

  def self.eval_line(line)
    if line.join == 'XXX'
      return :p1win
    elsif line.join == 'OOO'
      return :p2win
    end
  end

  def legal_move?(move)
    @data[move[0]][move[1]] == '_'
  end

  def lines
    [].tap do |all_lines|
      (0..2).each do |i| # check rows
        all_lines << @data[i]
      end
      (0..2).each do |i| # check columns
        all_lines << @data.map{|row| row[i]}
      end
      # check diagonals
      all_lines << [@data[0][0], @data[1][1], @data[2][2]]
      all_lines << [@data[0][2], @data[1][1], @data[2][0]]
    end
  end

  def eval_board
    line_results = lines.map{|l| Board.eval_line(l) }
    # any wins?
    line_results.each do |result|
      if (result == :p1win) || (result == :p2win)
        return result
      end
    end

    # draw?
    unless @data.flatten.include? '_'
      return :tie
    else
      return :keep_playing
    end
  end

  def at(i, j)
    @data[i][j]
  end
end

class HumanPlayer
  def take_move(board)
    puts "Human player, enter your move in the form 'row,column' (zero-based indexing)"
    input = gets.chomp
    input.split(',').map(&:to_i)
  end
end

class ComputerPlayer


  def initialize(mark)
    @mark = mark
    @victory_conditions = {'X' => :p1win, 'O' => :p2win}
  end

  def take_move(board)
    @victory_conditions[@mark]
    legal_moves = []
    (0..2).each do |row|
      (0..2).each do |col|
        if board.legal_move?([row,col])
          legal_moves << [row, col]
          what_if = board.counterfactual_mark([row, col], @mark)
          if what_if.eval_board == @victory_conditions[@mark]
            return [row, col]
          end
        end
      end
    end
    legal_moves.sample
  end
end

if __FILE__ == $PROGRAM_NAME
  our_game = Game.new(1)
  our_game.play
end