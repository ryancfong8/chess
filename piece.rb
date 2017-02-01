require_relative 'stepping_piece'
require_relative 'sliding_piece'
require 'singleton'

class Piece
  attr_reader :color, :type
  attr_accessor :pos

  include SteppingPiece

  def initialize(type, color, pos, board)
    @type = type
    @color = color
    @pos = pos
    @board = board
  end

  def valid?(move)
    return false unless in_bounds?(move)
    @board[move].class == NullPiece || @board[move].color != @color
  end

  def in_bounds?(pos)
    row, col = pos
    return true if row.between?(0,7) && col.between?(0,7)
    false
  end

  def attack?(move)
    return false unless in_bounds?(move)
    @board[move].class != NullPiece && @board[move].color != @color
  end

  def ddup(array)
    array.map { |el| el.is_a?(Array) ? ddup(el) : el }
  end

  def move_into_check?(end_pos)
    board_dup = Board.new(ddup(@board.grid))
    board_dup.move_piece(@pos, end_pos)
    board_dup.in_check?(@color)
  end

end

class Queen < Piece
  include SlidingPiece
  def initialize(type, color, pos, board)
    super
  end
end

class Rook < Piece
  include SlidingPiece
  def initialize(type, color, pos, board)
    super
  end
end

class Bishop < Piece
  include SlidingPiece
  def initialize(type, color, pos, board)
    super
  end
end

class Knight < Piece
  include SteppingPiece
  def initialize(type, color, pos, board)
    super
  end
end

class King < Piece
  include SteppingPiece
  def initialize(type, color, pos, board)
    super
  end
end

class Pawn < Piece
  def initialize(type, color, pos, board)
    super
  end

  def valid?(move)
    return false unless in_bounds?(move)
    @board[move].class == NullPiece
  end

  def pawn_moves(starting_row, move, special_move, attack_move1, attack_move2)
    valid_moves = []
    valid_moves << move if valid?(move)
    if @pos[0] == starting_row
      move = special_move
      valid_moves << move if valid?(move)
    end
    valid_moves << attack_move1 if attack?(attack_move1)
    valid_moves << attack_move2 if attack?(attack_move2)
    valid_moves
  end

  def moves
    if @color == 'white'
      valid_moves = pawn_moves(1, [@pos[0] + 1, @pos[1]], [@pos[0] + 2, @pos[1]], [@pos[0] + 1, @pos[1] + 1], [@pos[0] + 1, @pos[1] - 1])
    elsif @color == 'black'
      valid_moves = pawn_moves(6, [@pos[0] - 1, @pos[1]], [@pos[0] - 2, @pos[1]], [@pos[0] - 1, @pos[1] - 1], [@pos[0] - 1, @pos[1] + 1])
    end

    valid_moves
  end
end

class NullPiece < Piece
  include Singleton

  def initialize
    @type = :_
  end
end
