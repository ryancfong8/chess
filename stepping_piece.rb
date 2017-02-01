module SteppingPiece
  DIRECTION = {
    :king => [[1, 1], [-1, -1], [-1, 1], [1, -1], [0, 1], [0, -1], [1, 0], [-1, 0]],
    :knight => [[2, 1], [2, -1], [-2, 1], [-2, -1]]
  }

  def move_dirs(type)
    type == :K ? DIRECTION[:king] : DIRECTION[:knight]
  end


  def moves
    valid_moves = []
    possible_dirs = move_dirs(@type)

    possible_dirs.each do |dir|
      move = [dir[0] + @pos[0], dir[1] + @pos[1]]
      valid_moves << move if valid?(move)
    end

    valid_moves
  end
end
