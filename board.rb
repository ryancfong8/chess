require_relative 'piece'

class Board
  attr_accessor :grid

  def initialize(grid = Array.new(8){Array.new(8)})
    @grid = grid
  end

  def populate
    first_rows(0, 'white')
    first_rows(7, 'black')
    pawns(1, 'white')
    pawns(6, 'black')
    empty_spaces
  end

  def move_piece(start_pos, end_pos)
    begin
      raise "no piece at start pos" if self[start_pos].class == NullPiece
      raise "invalid move" if outside_scope?(end_pos)
    rescue => e
      puts "error: #{e.message}"
    end

    self[end_pos] = self[start_pos]
    self[end_pos].pos = end_pos
    self[start_pos] = NullPiece.instance
    @grid
  end

  def outside_scope?(pos)
    row, col = pos
    return false if row.between?(0,8) && col.between?(0,8)
    true
  end

  def fill(row, col, piece)
    @grid[row][col] = piece
  end


  def pawns(row, color)
    @grid[row].each_index do |col|
      fill(row, col, Pawn.new(:p, color, [row, col], self))
    end
  end

  def first_rows(row, color)
    @grid[row].each_index do |col|
      if col == 0 || col == 7
        fill(row, col, Rook.new(:R, color, [row, col], self))
      elsif col == 1 || col == 6
        fill(row, col, Knight.new(:H, color, [row, col], self))
      elsif col == 2 || col == 5
        fill(row, col, Bishop.new(:B, color, [row, col], self))
      elsif col == 3
        fill(row, col, Queen.new(:Q, color, [row, col], self))
      elsif col == 4
        fill(row, col, King.new(:K, color, [row, col], self))
      end
    end
  end

  def empty_spaces
    i = 2
    while i < 6
      @grid[i].map! do |pos|
        pos = NullPiece.instance
      end
      i+= 1
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def find_king(color)
    @grid.each_with_index do |row, index|
      row.each_with_index do |pos, idx|
        return [index, idx] if pos.class == King && pos.color == color
      end
    end
  end

  def enemies(color)
    enemy_list = []
    @grid.each_with_index do |row, index|
      row.each_with_index do |pos, idx|
        enemy_list << pos if pos.color == color
      end
    end

    enemy_list
  end

  def in_check?(color)
    king_pos = find_king(color)

    enemy_color = (color == 'white' ? 'black' : 'white')
    enemy_list = enemies(enemy_color)

    enemy_list.each do |enemy|
      enemy_moves = enemy.moves
      return true if enemy_moves.include?(king_pos)
    end

    false
  end

  def checkmate?(color)
    # true if player is in check, and none of the players pieces have any valid moves
    return false unless in_check?(color)
    # loop through all of our colors moves to see if one of those moves makes in_check? false
    pieces = enemies(color)
    pieces.each do |piece|
      piece_moves = piece.moves
      piece_moves.each do |move|
        return false unless piece.move_into_check?(move)
      end
    end
    true
  end
end
