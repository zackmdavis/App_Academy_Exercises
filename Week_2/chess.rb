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

end


class ChessBoard

  attr_accessor :board

  def initialize(board = nil)
    if board.nil?
      board = Array.new(8){ Array.new(8) }
      board[0][0] = Rook.new(self, [0,0], :black)
      board[0][1] = Knight.new(self, [0,1], :black)
      board[0][2] = Bishop.new(self, [0,2], :black)
      board[0][3] = Queen.new(self, [0,3], :black)
      board[0][4] = King.new(self, [0,4], :black)
      board[0][5] = Bishop.new(self, [0,5], :black)
      board[0][6] = Knight.new(self, [0,6], :black)
      board[0][7] = Rook.new(self, [0,7], :black)
      (0..7).each do |j|
        board[1][j] = Pawn.new(self, [1, j], :black)
      end
      (0..7).each do |j|
        board[6][j] = Pawn.new(self, [6, j], :white)
      end
      board[7][0] = Rook.new(self, [7,0], :white)
      board[7][1] = Knight.new(self, [7,1], :white)
      board[7][2] = Bishop.new(self, [7,2], :white)
      board[7][3] = Queen.new(self, [7,3], :white)
      board[7][4] = King.new(self, [7,4], :white)
      board[7][5] = Bishop.new(self, [7,5], :white)
      board[7][6] = Knight.new(self, [7,6], :white)
      board[7][7] = Rook.new(self, [7,7], :white)
    end
    @board = board
  end

  def in_bounds?(position)
    positions.all? { |coordinate| coordinate >= 0 and coordinate < 8 }
  end

  def at(position)
    @board[position[0]][position[1]]
  end

  def dup
    ChessBoard.new(@board.deep_dup)
  end

  def make_move(piece, position)
    piece.position = nil
    @board[position[0]][position[1]] = piece
    piece.position = position
  end

  def in_check?(color)
    false
  end

  def show
    print "  a b c d e f g h\n"

    @board.each_with_index do |row, row_index|
      print (8 - row_index).to_s
      row.each do |square|
        if square.nil?
          print "  "
        else
          print "#{square.icon} "
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

  def move(new_position)
  end

end

class SlidingPiece < ChessPiece

  def legal_moves
    moves = []
    @@directions.each do |direction|
      multiplier = 1
      while true
        offset = direction.map { |coordinate| multiplier * coordinate }
        candidate_move = [].tap do |candidate|
                           @position.each_with_index do |coordinate, i|
                             candidate.push(coordinate + offset[i])
                           end
                         end

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

    moves.reject { |move| @board.dup.make_move(self, move).in_check?(@color) }
  end
end

class SteppingPiece < ChessPiece

  def legal_moves
    moves = []
    @@offsets.each do |offset|
      candidate_move = [].tap do |candidate|
                           @position.each_with_index do |coordinate, i|
                             candidate.push(coordinate + offset[i])
                           end
                         end
      if ChessBoard.in_bounds?(candidate_move)
        if @board.at(candidate_move).nil?
          moves.push(candidate_move)
        elsif @board.at(candidate_move).color != @color
          moves.push(candidate_move)
        end
      end
    end
    moves.reject { |move| @board.dup.make_move(self, move).in_check?(@color) }
  end

end

class Pawn < ChessPiece
  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2659"
    elsif color == :black
      @icon = "\u265F".colorize(:red)
    end
  end
end

class King < SteppingPiece
  @@offsets = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2654"
    elsif color == :black
      @icon = "\u265A".colorize(:red)
    end
  end
end

class Queen < SlidingPiece
  @@directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2655"
    elsif color == :black
      @icon = "\u265B".colorize(:red)
    end
  end
end

class Rook < SlidingPiece
  @@directions = [[-1, 0], [0, -1], [0, 1], [1, 0]]

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2656"
    elsif color == :black
      @icon = "\u265C".colorize(:red)
    end
  end
end

class Bishop < SlidingPiece
  @@directions = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2657"
    elsif color == :black
      @icon = "\u265D".colorize(:red)
    end
  end
end

class Knight < SteppingPiece
  @@offsets = [[1,2], [2,1], [-1,2], [-2,1], [1,-2], [2,-1], [-1,-2], [-2,-1]]

  def initialize(board, position, color)
    super(board, position, color)
    if color == :white
      @icon = "\u2658"
    elsif color == :black
      @icon = "\u265E".colorize(:red)
    end
  end
end

board = ChessBoard.new
board.show