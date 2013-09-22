# A classic game of tic-tac-toe.
class TicTacToeGame

  def initialize
    setup
    play
  end

  @@turn_to_mark = { 0 => 'X', 1 => 'O' }
  # This hash maps a turn index to the corresponding player's mark.
  def self.turn_to_mark
    @@turn_to_mark
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
        @players << ComputerTicTacToePlayer.new('X')
        @players << ComputerTicTacToePlayer.new('O')
      elsif human_players == "1"
        @players << HumanTicTacToePlayer.new('X')
        @players << ComputerTicTacToePlayer.new('O')
      elsif human_players == "2"
        @players << HumanTicTacToePlayer.new
        @players << HumanTicTacToePlayer.new
      else
        print "I'm sorry, I didn't understand that. Please enter '0', '1', or '2'."
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
      @board.mark(move, @@turn_to_mark[@turn])

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
    orginal_state = self.state
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
      self.clone.mark(possible_move, mark)
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

class HumanTicTacToePlayer
  def take_move(board)
    puts "Human player, enter your move in the form 'row,column' (zero-based indexing)"
    input = gets.chomp
    input.split(',').map(&:to_i)
  end
end

class GametreeNode
  attr_accessor :parent, :children, :state, :value, :maximizing

  def initialize(state)
    @state = board
    @parent = nil
    @children = []
    @turn = turn
  end

  def possible_boards(mark)
    @state.possible_next_boards(mark)
  end

end

class ComputerTicTacToePlayer

  def initialize(mark)
    @mark = mark
  end

  def take_move(board)
    # TODO
  end

end

if __FILE__ == $PROGRAM_NAME
  TicTacToeGame.new
end
