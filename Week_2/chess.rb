require 'colorize'
require 'debugger'

module Chess

# A classic game of chess.
class ChessGame

  def initialize
    setup
    play
  end

  # Set up the board and players.
  def setup
    @board = ChessBoard.new
    @player1 = HumanPlayer.new(@board, :white)
    # @player2 = HumanPlayer.new(@board, :black)
    @player2 = AIPlayer.new(@board, :black)
  end

  # Play the game.
  def play
    white_playing = true
    playing = @player1
    until ChessBoard.checkmated?(@board, :white) or ChessBoard.checkmated?(@board, :black)
      if playing == @player1
        while true
          @board.show
          playing.select_piece
          @board.show
          break if playing.select_move
        end
      elsif playing == @player2
        playing.select_move
      end

      case white_playing
      when true
        playing = @player2
      when false
        playing = @player1
      end
      white_playing = !white_playing
    end

    @board.cursor_location = [nil, nil]
    @board.show

    victory_message = ChessBoard.checkmated?(@board, :white) ? "Black wins!!" : "White wins!!"
    puts victory_message
  end

end

# This class represents a human chess player.
class HumanPlayer

  def initialize(board, color)
    @board = board
    @color = color
  end

  # Gets a single keypress.
  def get_char
    # Thanks to http://stackoverflow.com/questions/8142901/ruby-stdin-getc-does-not-read-char-on-reception
    begin
      system("stty raw -echo")
      str = STDIN.getc
    ensure
      system("stty -raw echo")
    end
    str.chr
  end

  # Converts keypress outcome into a command.
  def get_command
    while true
      command = get_char.downcase
      case command
      when 'z'
        return true
      when 'x'
        return false
      when 'q'
        puts "Are you sure you want to quit?? Y/N"
        really = get_char.downcase
        if really == 'y'
          abort("Quit")
        else
          @board.show
          return get_command
        end
      else
        move_cursor(command)
      end
    end
  end

  # Moves the cursor.
  def move_cursor(command_key)
    new_location = @board.cursor_location.dup
    case command_key
    when 'i'
      new_location[0] -= 1
    when 'j'
      new_location[1] -= 1
    when 'k'
      new_location[0] += 1
    when 'l'
      new_location[1] += 1
    end
    if ChessBoard.in_bounds?(new_location)
      @board.cursor_location = new_location
      @board.show
    end
  end

  # Queries the user for the desired promotion, and performs the promotion.
  def promote_pawn
    puts "What would you like to promote the pawn to?"
    puts "(Q = Queen, K = Knight, R = Rook, B = Bishop)"
    promotion = nil
    case get_char.downcase
    when "q"
      promotion = Queen
    when "k"
      promotion = Knight
    when "r"
      promotion = Rook
    when "b"
      promotion = Bishop
    end
    promoted = promotion.new(@board, @selected_piece.position, @selected_piece.color)
    @board.board[@selected_piece.position[0]][@selected_piece.position[1]] = promoted
    @board.message = "Last move: #{@selected_piece.icon} #{ChessBoard::FILES[@selected_piece.position[1]]}" +
      "#{ChessBoard::RANKS[@selected_piece.position[0]]} = #{promoted.icon}"
  end

  # Uses user input to select a move.
  def select_move
    unless get_command
      @board.possible_moves = []
      return false
    end
    if @board.possible_moves.include?(@board.cursor_location)

      # special case: set en passant flag
      if  @selected_piece.is_a?(Pawn) && (@board.cursor_location[0] - @selected_piece.position[0]).abs == 2
        @selected_piece.en_passant_vulnerable = true
      end

      @board.make_move(@selected_piece, @board.cursor_location)

      # special case: pawn promotion
      if @selected_piece.is_a?(Pawn) && (@board.cursor_location[0] == 0 || @board.cursor_location[0] == 7)
        promote_pawn
      end

      @board.possible_moves = []
    else
      return select_move
    end
    true
  end

  # Uses user input to select a piece.
  def select_piece
    while true
      break if get_command
    end
    piece = @board.at(@board.cursor_location)
    if !piece.nil? && piece.color == @color
      legal_moves = piece.legal_moves
      if legal_moves.empty?
        select_piece
      else
        @board.possible_moves = legal_moves
        @selected_piece = piece
      end
    else
      select_piece
    end
  end
end


# A node in a game tree for use by AI players.
class GametreeNode

  TURN_TO_COLOR = {0 => :white, 1 => :black}

  attr_accessor :value, :parent, :children, :previous_move
  attr_reader   :state, :turn

  def initialize(state, turn, value = nil, parent = nil, previous_move = nil, children = nil)
    @state = state
    @turn = turn
    @value = value
    @parent = parent
    @previous_move = previous_move
    @children = children
  end

  # Minimax search down from this node.
  def negamax_search(depth)
    if depth == 0
      @value = AIPlayer.heuristic_evaluation_function(state)
    else
      child_boards = ChessBoard.possible_next_boards(@state, TURN_TO_COLOR[(@turn + 1) % 2])
      if child_boards.empty?
        @value = AIPlayer.heuristic_evaluation_function(state)
      else
        @children = child_boards.map do |board| 
          child = GametreeNode.new(board[1], (@turn + 1) % 2)
          child.parent = self
          child.previous_move = board[0]
          child
        end
        @children.each { |child| child.negamax_search(depth-1) }
        if turn == 0 # first player maximizing
          @value = @children.map { |child| child.value }.max
        elsif turn == 1 # second player minimizing
          @value = @children.map { |child| child.value }.min
        end
      end
    end
    return @value
  end

end


class AIPlayer

  PIECE_VALUES = {"Chess::Pawn" => 1, "Chess::Knight" => 3, "Chess::Bishop" => 3, "Chess::Rook" => 5, "Chess::Queen" => 9, "Chess::King" => 1}

  def initialize(board, color)
    @board = board
    @color = color
  end

  def AIPlayer.heuristic_evaluation_function(board)
    if ChessBoard.checkmated?(board, :black)
      return 500
    elsif ChessBoard.checkmated?(board, :white)
      return -500
    else
      score = 0
      board.board.each do |row|
        row.each do |square|
          unless square.nil?
            piece = square
            piece_value = PIECE_VALUES[piece.class.to_s]
            p piece
            p piece.class.to_s
            player_multiplier = (piece == :white) ? 1 : -1
            score += piece_value * player_multiplier
          end
        end
      end
      return score
    end
  end

  def select_move
    # At the moment, let's just assume the AI is the second player
    gametree_root = GametreeNode.new(@board, 1)
    gametree_root.negamax_search(2)
    move_node = gametree_root.children.find do |child|
      child.value == gametree_root.value
    end
    piece, move = move_node.previous_move
    @board.make_move(piece, move)
  end

end

class ChessBoard

  attr_accessor :board, :cursor_location, :possible_moves, :message

  RANKS = ['8', '7', '6', '5', '4', '3', '2', '1']
  FILES = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']

  def initialize(options = {})
    defaults = { empty: false }
    options = defaults.merge(options)

    board = Array.new(8){ Array.new(8) }

    unless options[:empty]
      place_major_pieces(board, :black)
      (0..7).each do |j|
        board[1][j] = Pawn.new(self, [1, j], :black)
      end
      (0..7).each do |j|
        board[6][j] = Pawn.new(self, [6, j], :white)
      end
      place_major_pieces(board, :white)
    end
    @board = board
    @cursor_location = [0,0]
    @possible_moves = []
    @message = "Welcome to chess!\n'IJKL' to move cursor\n'Z' to select a piece/move" +
      "\n'X' to unselect"
  end

  def place_major_pieces(board, color)
    if color == :black
      row = 0
    elsif color == :white
      row = 7
    end

    pieces = [Proc.new{ | position | Rook.new(self, position, color) },
              Proc.new{ | position | Knight.new(self, position, color) },
              Proc.new{ | position | Bishop.new(self, position, color) },
              Proc.new{ | position | Queen.new(self, position, color) },
              Proc.new{ | position | King.new(self, position, color) },
              Proc.new{ | position | Bishop.new(self, position, color) },
              Proc.new{ | position | Knight.new(self, position, color) },
              Proc.new{ | position | Rook.new(self, position, color) }]

    pieces.each_with_index do |piece, index|
      board[row][index] = piece.call([row, index])
    end
  end

  def ChessBoard.in_bounds?(position)
    position.all? { |coordinate| coordinate >= 0 and coordinate < 8 }
  end

  def at(position)
    @board[position[0]][position[1]]
  end

  def dup
    new_board = ChessBoard.new({ empty: true })

    @board.each_with_index do |row, index|
      new_row = []
      row.each do |square|
        if square.nil?
          new_row.push(nil)
        else
          new_row.push(square.class.new(new_board, [square.position[0], square.position[1]], square.color))
        end
      end
      new_board.board[index] = new_row
    end

    new_board
  end

  def each_of_color(color, &prc)
    @board.each do |row|
      row.each do |square|
        unless square.nil?
          if square.color == color
            prc.call(square)
          end
        end
      end
    end
  end

  def make_move(piece, position)
    if @board[position[0]][position[1]]
      @message = "Last move: #{piece.icon} x#{FILES[position[1]]}#{RANKS[position[0]]}"
    else
      @message = "Last move: #{piece.icon} #{FILES[position[1]]}#{RANKS[position[0]]}"
    end
    piece.moved = true
    @board[piece.position[0]][piece.position[1]] = nil
    @board[position[0]][position[1]] = piece

    # special case for castling
    if piece.is_a?(King) and ((position[1] - piece.position[1]).abs == 2)
      if (position[1] - piece.position[1]) == 2
        make_move(@board[position[0]][7], [position[0], position[1]-1])
        @message = "Last move: O-O"
      else
        make_move(@board[position[0]][0], [position[0], position[1]+1])
        @message = "Last move: O-O-O"
      end
    end

    # special case for en passant capture
    if piece.is_a?(Pawn)
      [-1, 1].each do |j|
        if position[1] == piece.position[1] + j
          pawn = @board[piece.position[0]][piece.position[1]+j]
          if !pawn.nil? and pawn.is_a?(Pawn) and pawn.en_passant_vulnerable
            @board[piece.position[0]][piece.position[1]+j] = nil
            @message = "Last move: #{piece.icon} x#{FILES[position[1]]}#{RANKS[position[0]]} e.p."
          end
        end
      end
    end

    # deactivate any en passant flags
    each_of_color(piece.color == :white ? :black : :white) do |piece|
      if piece.is_a?(Pawn) and piece.en_passant_vulnerable
        piece.en_passant_vulnerable = false
      end
    end

    piece.position = position
    self
  end

  def ChessBoard.possible_next_boards(board, color)
    next_boards = []
    board.each_of_color(color) do |piece|
      position = piece.position
      piece.legal_moves.each do |move|
        next_board = board.dup
        next_board.make_move(next_board.at(position), move)
        next_boards.push([[piece, move], next_board])
      end
    end
    next_boards
  end

  def ChessBoard.find_king(board, color)
    board.each_of_color(color) do |piece|
      if piece.is_a?(King)
        return piece.position
      end
    end
  end

  def ChessBoard.in_check?(board, color)
    attackers = (color == :white) ? :black : :white
    king_position = ChessBoard.find_king(board, color)

    board.each_of_color(attackers) do |attacking_piece|
      attacking_piece.naive_moves.each do |move|
        if move == king_position
          return true
        end
      end
    end
    return false
  end

  def ChessBoard.checkmated?(board, color)
    escaping_moves = []
    board.each_of_color(color) do |defending_piece|
      escaping_moves += defending_piece.legal_moves
    end
    escaping_moves.empty?
  end

  def ChessBoard.square_colored?(position)
    if (position[0]+position[1]) % 2 == 1
      return true
    else
      return false
    end
  end

  def show
    system("clear")
    print " a b c d e f g h\n"
    square_color = {true => :black, false => :red}

    @board.each_with_index do |row, row_index|
      print (8 - row_index).to_s
      row.each_with_index do |square, col_index|
        if [row_index, col_index] == @cursor_location
          print "\u2B21 ".colorize(:color => :cyan, :background => square_color[ChessBoard.square_colored?([row_index, col_index])])
        elsif possible_moves.include?([row_index, col_index])
          print "X ".colorize(:color => :cyan, :background => square_color[ChessBoard.square_colored?([row_index, col_index])])
        elsif square.nil?
          print "  ".colorize(:background => square_color[ChessBoard.square_colored?([row_index, col_index])])
        else
          print square.icon.colorize(:background => square_color[ChessBoard.square_colored?([row_index, col_index])])
          print " ".colorize(:background => square_color[ChessBoard.square_colored?([row_index, col_index])])
        end
      end
      print "\n"
    end
    puts @message
  end

end

class ChessPiece

  attr_accessor :board, :position, :color, :icon, :moved

  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
    @moved = false
  end

  def move_from_offset(offset)
    [].tap do |candidate|
      @position.each_with_index do |coordinate, i|
        candidate.push(coordinate + offset[i])
      end
    end
  end

  def reject_check_moves(moves)
    moves.reject do |move|
      new_board = @board.dup
      new_board = new_board.make_move(new_board.at(@position), move)
      ChessBoard.in_check?(new_board, @color)
    end
  end

  def legal_moves
    moves = naive_moves
    reject_check_moves(moves)
  end

end

class SlidingPiece < ChessPiece

  def naive_moves
    moves = []
    directions.each do |direction|
      multiplier = 1
      while true
        offset = direction.map { |coordinate| multiplier * coordinate }
        candidate_move = move_from_offset(offset)
        if !ChessBoard.in_bounds?(candidate_move)
          break
        elsif !@board.at(candidate_move).nil?
          if @board.at(candidate_move).color == @color
            break
          else
            moves << candidate_move
            break
          end
        end

        moves << candidate_move
        multiplier += 1
      end
    end
    moves
  end
end

class SteppingPiece < ChessPiece

  def naive_moves
    moves = []
    offsets.each do |offset|
      candidate_move = move_from_offset(offset)
      if ChessBoard.in_bounds?(candidate_move)
        if @board.at(candidate_move).nil?
          moves.push(candidate_move)
        elsif @board.at(candidate_move).color != @color
          moves.push(candidate_move)
        end
      end
    end
    moves
  end

end

class Pawn < ChessPiece

  attr_accessor :en_passant_vulnerable

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2659".colorize(:yellow)
      @forward = -1
    elsif color == :black
      @icon = "\u265F".colorize(:green)
      @forward = 1
    end
    @en_passant_vulnerable = false
  end

  def naive_moves
    moves = []
    if @board.at([@position[0]+@forward, @position[1]]).nil?
      moves.push([@position[0]+@forward, @position[1]])

      # can move two spaces on first move
      home_row = self.color == :white ? 6 : 1
      if self.position[0] == home_row &&  @board.at([@position[0]+2*@forward, @position[1]]).nil?
        moves.push([@position[0]+2*@forward, @position[1]])
      end
    end

    [-1, 1].each do |j|
      piece = @board.at([@position[0]+@forward, @position[1]+j])
      if !piece.nil? and piece.color != @color
        moves.push([@position[0]+@forward, @position[1]+j])
      end
      # check if en passant capture is available
      piece = @board.at([@position[0], @position[1]+j])
      if !piece.nil? and piece.is_a?(Pawn) and piece.en_passant_vulnerable
        moves.push([@position[0]+@forward, @position[1]+j])
      end
    end

    moves.select { |move| ChessBoard.in_bounds?(move) }
  end
end

class King < SteppingPiece

  alias :super_legal_moves :legal_moves

  def offsets
    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  end

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2654".colorize(:yellow)
    elsif color == :black
      @icon = "\u265A".colorize(:green)
    end
  end

  def can_castle?(direction)
    rook_file = (direction == -1) ? 0 : 7
    rook = @board.at([@position[0], rook_file])
    unless rook.is_a?(Rook)
      return false
    end
    if @moved or rook.moved
      return false
    end
    between = (direction == -1) ? (rook_file+1...@position[1]).to_a : (@position[1]+1...rook_file)
    between.each do |j|
      unless @board.at([@position[0],j]).nil?
        return false
      end
    end

    moves = [[@position[0], @position[1]+(direction*2)], [@position[0], @position[1]+(direction)]]

    unless moves == reject_check_moves(moves)
      return false
    end

    true
  end

  def legal_moves
    moves = super_legal_moves
    if can_castle?(1)
      moves << [@position[0], @position[1]+2]
    end
    if can_castle?(-1)
      moves << [@position[0], @position[1]-2]
    end
    moves
  end

end

class Queen < SlidingPiece
  def directions
    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  end

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2655".colorize(:yellow)
    elsif color == :black
      @icon = "\u265B".colorize(:green)
    end
  end
end

class Rook < SlidingPiece
  def directions
    [[-1, 0], [0, -1], [0, 1], [1, 0]]
  end

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2656".colorize(:yellow)
    elsif color == :black
      @icon = "\u265C".colorize(:green)
    end
  end
end

class Bishop < SlidingPiece
  def directions
    [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  end

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2657".colorize(:yellow)
    elsif color == :black
      @icon = "\u265D".colorize(:green)
    end
  end
end

class Knight < SteppingPiece
  def offsets
    [[1,2], [2,1], [-1,2], [-2,1], [1,-2], [2,-1], [-1,-2], [-2,-1]]
  end

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2658".colorize(:yellow)
    elsif color == :black
      @icon = "\u265E".colorize(:green)
    end
  end
end

end # end chess module

if __FILE__ == $PROGRAM_NAME
  Chess::ChessGame.new
end
