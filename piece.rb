class Piece
  attr_reader :color, :type
  include SlidingPiece
  include SteppingPiece
  def initialize(type, color)
    @type = type
    @color = color
  end

  def moves
    # return an array of places a piece can move to
  end

  def move_dirs
    # for bishop, rook, queen moves
  end
end

class Pawns < Piece
  def initialize(type, color)
  end

  def moves
    # can move up, down, right, left, diagonally
    # [+1,0]
    # can do these moves if attacking
    # [+1,+1], [+1,-1]
  end
end

class NullPiece < Piece
  def initialize
    @type = nil
  end
end

module SlidingPiece
  def initialize(type, color)
  end

  def moves
    #bishop can only go diagonally, as many spaces as possible
    # [+n,+n], [-n,-n], [-n, +n], [+n, -n]

    #rook can go up, down, right left as many spaces as possible
    # [+n, 0], [-n, 0], [0, +n], [0, -n]

    # queen can go anywhere to the max
    # [+n,+n], [-n,-n], [-n, +n], [+n, -n], [+n, 0], [-n, 0], [0, +n], [0, -n]

  end
end

module SteppingPiece
  def initialize(type, color)
  end

  def moves
    # king can move one space in any direction:
      # [+1, 0], [+1, +1], [0,+1], [+1,-1], [0, -1], [-1,0], [-1,-1], [-1,+1]

    # knight has 4 options:
      # current pos [+2, +1]
      # current pos [+2, -1]
      # current pos [-2, +1]
      # current pos [-2, -1]
  end
end
