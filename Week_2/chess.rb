class ChessGame

end


class ChessBoard
end

class ChessPiece

  attr_accessor :board, :position, :color

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

  end

end

class SteppingPiece < ChessPiece
end

class Pawn < ChessPiece
end

class King < SteppingPiece
end

class Queen < SlidingPiece
  @@directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
end

class Rook < SlidingPiece
  @@directions = [[-1, 0], [0, -1], [0, 1], [1, 0]]
end

class Bishop < SlidingPiece
  @@directions = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
end

class Knight < SteppingPiece
end