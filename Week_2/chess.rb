require 'colorize'

class Array
  def deep_dup
    self.each do |elem|
      if elem.is_a?(Array)
        elem.deep_dup
      elsif !elem.nil?
        elem.dup
      end
    end
  end
end

class ChessGame

  def initialize
    setup
    play
  end

  def setup
    @board = ChessBoard.new
    @player1 = HumanPlayer.new(@board, :white)
    @player2 = HumanPlayer.new(@board, :black)
  end

  def play
    white_playing = true
    playing = @player1
    until @board.checkmated?(:white) or @board.checkmated?(:black)
      while true
        @board.show
        playing.select_piece
        @board.show
        break if playing.select_move
      end

      case white_playing
      when true
        playing = @player2
      when false
        playing = @player1
      end
      white_playing = !white_playing
    end

  end

end

class HumanPlayer

  def initialize(board, color)
    @board = board
    @color = color
  end

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

  def get_command
    while true
      command = get_char
      case command
      when 'z'
        return true
      when 'x'
        return false
      when 'q'
        abort("Quit")
      else
        move_cursor(command)
      end
    end
  end

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

  def select_move
    return false unless get_command
    if @board.possible_moves.include?(@board.cursor_location)
      @board.make_move(@selected_piece, @board.cursor_location)
      @board.possible_moves = []
    else
      return select_move
    end
    true
  end

  def select_piece
    while true
      break if get_command
    end
    piece = @board.at(@board.cursor_location)
    if !piece.nil? && piece.color == @color
      legal_moves = piece.legal_moves
      @board.possible_moves = legal_moves
      @selected_piece = piece
    else
      select_piece
    end
  end

end


class ChessBoard

  attr_accessor :board, :cursor_location, :possible_moves

  def initialize(board = nil)
    if board.nil?
      board = Array.new(8){ Array.new(8) }

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
    ChessBoard.new(@board.deep_dup)
  end

  def make_move(piece, position)
    @board[piece.position[0]][piece.position[1]] = nil
    @board[position[0]][position[1]] = piece
    piece.position = position
    self
  end

  def in_check?(color)
    false # placeholder
  end

  def checkmated?(color)
    false # placeholder
  end

  def ChessBoard.square_colored?(position)
    if (position[0]+position[1]) % 2 == 1
      return true
    else
      return false
    end
  end

  def show
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
  end

end

class ChessPiece

  attr_accessor :board, :position, :color, :icon

  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
  end

  def move_from_offset(offset)
    [].tap do |candidate|
      @position.each_with_index do |coordinate, i|
        candidate.push(coordinate + offset[i])
      end
    end
  end

  def reject_check_moves(moves)
    moves.reject { |move| @board.dup.make_move(self, move).in_check?(@color) }
  end

end

class SlidingPiece < ChessPiece

  def legal_moves
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
    reject_check_moves(moves)
  end
end

class SteppingPiece < ChessPiece

  def legal_moves
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
    reject_check_moves(moves)
  end

end

class Pawn < ChessPiece
  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2659".colorize(:yellow)
      @forward = -1
    elsif color == :black
      @icon = "\u265F".colorize(:green)
      @forward = 1
    end
  end

  def legal_moves
    moves = []
    if @board.at([@position[0]+@forward, @position[1]]).nil?
      moves.push([@position[0]+@forward, @position[1]])
    end
    [-1, 1].each do |j|
      piece = @board.at([@position[0]+@forward, @position[1]+j])
      if !piece.nil? and piece.color != @color
        moves.push([@position[0]+@forward, @position[1]+j])
      end
    end
    moves = reject_check_moves(moves)
    moves.select { |move| ChessBoard.in_bounds?(move) }
  end
end

class King < SteppingPiece
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

game = ChessGame.new