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

# monkeypatch Array to give us deep duplication
class Array
  def deep_dup
    arr = []
    self.each do |el|
      if el.is_a?(Array)
        arr << el.deep_dup
      else
        arr << el
      end
    end
    arr
  end
end


class BoardNode
  attr_accessor :parent, :children, :mark, :turn

  def initialize(board, turn)
    @value = board
    @parent = nil
    @children = []
    @turn = turn
  end

  def possible_boards(mark)
    @value.possible_boards(mark)
  end

  # def is_nonlosing_node?(node, turn)
  #   if turn == 0
  #     loss_symbol = :p2win
  #   elsif turn == 1
  #     loss_symbol = :p1win
  #   end
  #   self.children.each do |child|
  #     if child.children.all? { |grandchild| grandchild.value.eval_board != loss_symbol }
  #   end
  # end

  # def is_winning_node?(turn)
  #   if turn == 0
  #     win_symbol = :p1win
  #   elsif turn == 1
  #     win_symbol = :p2win
  #   end
  #   if self.value.eval_board == win_symbol
  #     return true
  #   end
  #   winning? = self.children.all? do |child|
  #     child.children.any? { |grandchild| grandchild.is_winning_node?(turn) }
  #   end
  #   winning?
  # end
  #
  # def is_losing_node?(turn)
  #   self.is_winning_node?((turn+1)%2)
  # end

end


class Board
  attr_accessor :data

  def initialize(data = (1..3).map{|_| (1..3).map{|_| '_'}})
    @data = data
  end

  def mark(move, mark)
    @data[move[0]][move[1]] = mark
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

  def legal_moves
    all_moves = [[0,0], [0,1], [0,2], [1,0], [1,1], [1,2], [2,0], [2,1], [2,2]]
    all_moves.select{|move| @data[move[0]][move[1]] == '_'}
  end

  def possible_boards(mark)
    possible_moves = self.legal_moves
    possible_boards = (0...possible_moves.length).map{|i| Board.new(@data.deep_dup)}
    possible_boards.each_with_index do |poss_board, i|
      poss_board.mark(possible_moves[i], mark)
    end
    possible_boards
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

  attr_accessor :root

  def initialize(mark)
    @mark = mark
  end

  def build_game_tree(board, turn)
    turn_to_mark = {0 => 'X', 1 => 'O'}
    @root = BoardNode.new(board, turn)
    to_evaluate = []
    to_evaluate.push(@root)
    counter = 0
    until to_evaluate.empty?
      counter += 1
      p counter
      evaluating = to_evaluate.shift
      children = evaluating.possible_boards(turn_to_mark[(evaluating.turn+1) % 2])
      children.map!{|child| BoardNode.new(child, (evaluating.turn+1) % 2)}
      evaluating.children = children
      evaluating.children.each do |child|
          to_evaluate.push(child)
      end
    end
  end

  def take_move(board)
    if root.nil?
      build_game_tree(board, 1)
    end


  end


end

# if __FILE__ == $PROGRAM_NAME
#   our_game = Game.new(1)
#   our_game.play
# end

# test_ai = ComputerPlayer.new('O')
# test_board1 = Board.new([['_','X','X'],['X','O','_'],['O','X','O']])
# test_ai.build_game_tree(test_board1, 1)
# p test_ai.def root

test_ai = ComputerPlayer.new('O')
test_board = Board.new([['_','_','_'],['_','X','_'],['O','_','_']])
test_ai.build_game_tree(test_board, 0)
