require 'debugger'

# A classic game of tic-tac-toe.
class TicTacToeGame

  def initialize
    setup
    play
  end

  # This hash maps a turn index to the corresponding player's mark.
  @@turn_to_mark = { 0 => 'X', 1 => 'O' }
  def self.turn_to_mark
    @@turn_to_mark
  end

  # This hash maps a player's mark to the corresponding turn index.
  @@mark_to_turn = { 'X' => 0, 'O' => 1 }
  def self.mark_to_turn
    @@mark_to_turn
  end

  # Sets up the game.
  def setup
    @board = TicTacToeBoard.new
    @game_over = false

    # player objects are stored in the two-element array @players
    @players = []
    # @turn indicates whose turn it is and indexes into @players
    @turn = 0

    human_players = nil
    until human_players
      puts "How many human players?"
      human_players = gets.chomp
      if human_players == "0"
        @players << ComputerTicTacToePlayer.new('X', 0)
        @players << ComputerTicTacToePlayer.new('O', 1)
      elsif human_players == "1"
        @players << HumanTicTacToePlayer.new('X', 0)
        @players << ComputerTicTacToePlayer.new('O', 1)
      elsif human_players == "2"
        @players << HumanTicTacToePlayer.new('X', 0)
        @players << HumanTicTacToePlayer.new('O', 1)
      else
        print "I'm sorry, I didn't understand that. Please enter '0', '1', or '2'. "
        human_players = nil
      end
    end
  end

  # Play!
  def play

    until @game_over
      # display the board
      @board.show

      # take a move
      move = @players[@turn].take_move(@board)
      until @board.legal_move?(move)
        puts "That move is not legal; try again!"
        move = @players[@turn].take_move(@board)
      end

      # mark the board
      @board.mark(move, TicTacToeGame.turn_to_mark[@turn])

      # evaluate the board, declare outcome as appopriate
      result = @board.evaluate
      if result
        @game_over = true
        if result == 0 # first player win
          puts "Player 1 ('X') wins!"
          puts "Player 2 ('O') has been utterly defeated."
          return 0
        elsif result == 1 # second player win
          puts "Player 2 ('O') wins!"
          puts "Player 1 ('X') has been utterly defeated."
          return 1
        elsif result == 2 # tie
          puts "The game was a tie, a 'cat's game.'"
          return 2
        end
      end

      # Now it's the other player's turn---
      @turn = (@turn + 1) % 2
    end
  end

end

# The tic-tac-toe arena.
class TicTacToeBoard

  attr_accessor :state

  # Creates the board (empty by default).
  def initialize(state = (1..3).map{ |_| (1..3).map{|_| '_'} })
    @state = state
  end

  # Returns the mark at indices i, j.
  def at(i, j)
    @state[i][j]
  end

  # Marks the board: +move+ is a two-element array, +mark+ is the
  # player's mark
  def mark(move, mark)
    @state[move[0]][move[1]] = mark
  end

  # Displays the board.
  def show
    puts
    @state.each do |row|
      row.each do |mark|
        print mark, ' '
      end
      print "\n"
    end
    puts
  end

  # Overrides +#clone+ to give deep duplication.
  def clone
    original_state = @state
    copied_state = (0..2).map{ |row| original_state[row].dup }
    TicTacToeBoard.new(copied_state)
  end

  # Return true if the supplied move is legal.
  def legal_move?(move)
    at(move[0], move[1]) == '_'
  end

  # Returns an array of all legal moves.
  def legal_moves
    all_moves = [[0,0], [0,1], [0,2], [1,0], [1,1], [1,2], [2,0],
                 [2,1], [2,2]]
    all_moves.select{|move| at(move[0], move[1]) == '_'}
  end

  # Returns an array of possible next boards given mark of player to
  # move next.
  def possible_next_boards(mark)
    possible_moves = legal_moves
    possible_boards = possible_moves.map do |possible_move|
      next_board = self.clone
      next_board.mark(possible_move, mark)
      next_board
    end
    possible_boards
  end

  # Returns 0, 1, 2, or false for first player win, second player win,
  # tie, and game-not-over-yet, respectively.
  def evaluate
    line_results = lines.map{ |l| TicTacToeBoard.evaluate_line(l) }
    if line_results.any? # win
      return line_results.select{ |result| result }[0]
    elsif legal_moves.empty? # tie
      return 2
    else # keep playing
      return false
    end
  end

  # Returns a move location at which supplied +current+ and +target+
  # boards are different.
  def self.move_to_achieve_state(current, target)
    (0..2).each do |row|
      (0..2).each do |col|
        if current.at(row, col) != target.at(row, col)
          return [row, col]
        end
      end
    end
  end

  private

  # Returns 0 (respectively 1) if the supplied array of marks
  # indicates a win for the first (respectively second) player.
  def self.evaluate_line(line)
    if line.join == 'XXX'
      return 0
    elsif line.join == 'OOO'
      return 1
    else
      return false
    end
  end

  # Returns array of marks for all rows, diagonals, and columns.
  def lines
    [].tap do |all_lines|
      (0..2).each do |row| # check rows
        all_lines << (0..2).map{ |col| at(row, col) }
      end
      (0..2).each do |col| # check columns
        all_lines << (0..2).map{ |row| at(row, col) }
      end
      # check diagonals
      all_lines << (0..2).map{ |i| at(i, i) }
      all_lines << (0..2).map{ |i| at(i, 2-i) }
    end
  end

end

# This class represents a human player.
class HumanTicTacToePlayer

  attr_accessor :mark

  def initialize(mark, turn)
    @mark = mark
  end

  # Records the human's move.
  def take_move(board)
    puts "Human player, enter your move like 'row, column'"
    input = gets.chomp
    input.split(',').select{ |chr| chr != ' '}.map(&:to_i)
  end

end

# This class represents a node in a game tree for use by AI players.
class GametreeNode

  attr_accessor :value, :parent, :children
  attr_reader   :state, :turn

  def initialize(state, turn, value = nil, parent = nil, children = nil)
    @state = state
    @turn = turn
    @value = value
    @parent = parent
    @children = children
  end

  # Minimax search down from this node.
  def negamax_search
    evaluation = @state.evaluate
    if evaluation == 0 # first player win
      @value = 1
    elsif evaluation == 1 # second player win
      @value = -1
    elsif evaluation == 2 # tie
      @value = 0
    else
      #p @state
      child_states = @state.possible_next_boards(
           TicTacToeGame.turn_to_mark[turn])
      #p child_states
      @children = child_states.map do |state|
        GametreeNode.new(state, (turn + 1) % 2)
      end
      @children.each{ |child| child.parent = self }
      @children.each{ |child| child.negamax_search }
      if turn == 0 # first player maximizing
        @value = @children.map{ |child| child.value }.max
      elsif turn == 1 # second player minimizing
        @value = @children.map{ |child| child.value }.min
      end
    end
    return @value
  end

end

# Currently under development!
class ComputerTicTacToePlayer

  attr_accessor :gametree_root

  def initialize(mark, turn)
    @mark = mark
    @turn = 1
    @gametree_root = nil
  end

  # Build or reroot the game tree as necessary.
  def gametree_surgery(board)
    if @gametree_root.nil?
      @gametree_root = GametreeNode.new(board, TicTacToeGame.mark_to_turn[@mark])
    else
      @gametree_root.children.each do |child|
        if child.state == board
          @gametree_root = child
          break
        end
      end
    end
  end

  # Record the AI's move.
  def take_move(board)
    # For the first move, pick randomly (because searching the entire
    # game tree is expensive).
    debugger
    if board.legal_moves.length > 7
      return board.legal_moves.sample
    else
      gametree_surgery(board)
      if gametree_root.children.nil?
        gametree_root.negamax_search
      end
      if @turn == 0 # first player maximizing
        new_board_node = gametree_root.children.max do |child1, child2|
          child1.value <=> child2.value
        end
      elsif @turn == 1 # second player minimizing
        new_board_node = gametree_root.children.min do |child1, child2|
          child1.value <=> child2.value
        end
      end
      @gametree_root = new_board_node
      move = TicTacToeBoard.move_to_achieve_state(board, new_board_node.state)
      move
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  TicTacToeGame.new
end
