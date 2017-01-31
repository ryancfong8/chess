require_relative 'piece'

class Board
  attr_accessor :grid

  def initialize(grid = Array.new(8){Array.new(8)})
    @grid = grid
  end

  def populate
    first_rows(0, 'white')
    first_rows(7, 'black')
    empty_spaces
    pawns
  end

  def move_piece(start_pos, end_pos)
    begin
      raise "no piece at start pos" if self[start_pos].class == NullPiece
      raise "invalid move" if outside_scope?(end_pos)
    rescue => e
      puts "error: #{e.message}"
    end

    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.new
    @grid
  end

  def outside_scope?(pos)
    row, col = pos
    return false if row.between?(0,8) && col.between?(0,8)
    true
  end

  def fill(row, col, piece, color)
    @grid[row][col] = Piece.new(piece, color)
  end

  def first_rows(row, color)
    @grid[row].each_index do |col|
      if col == 0 || col == 7
        fill(row, col, 'rook', color)
      elsif col == 1 || col == 6
        fill(row, col, 'knight', color)
      elsif col == 2 || col == 5
        fill(row, col, 'bishop', color)
      elsif col == 3
        fill(row, col, 'queen', color)
      elsif col == 4
        fill(row, col, 'king', color)
      end
    end
  end

  def empty_spaces
    i = 2
    while i < 6
      @grid[i].map! do |pos|
        pos = NullPiece.new
      end
      i+= 1
    end
  end

  def pawns
    @grid[1].map! do |pos|
      pos = Piece.new('pawn', 'white')
    end

    @grid[6].map! do |pos|
      pos = Piece.new('pawn', 'black')
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def[]=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end
end
