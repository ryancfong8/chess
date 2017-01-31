class Piece
  attr_reader :color, :type
  def initialize(type, color)
    @type = type
    @color = color
  end
end

class SlidingPiece < Piece
  # bishop, rook, queen
end

class SteppingPiece < Piece
end

class NullPiece < Piece
  def initialize
    @type = nil
  end
end
