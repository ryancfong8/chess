require 'byebug'
module SlidingPiece
  DIRECTION = {
    :diagonal => [[1, 1], [-1, -1], [-1, 1], [1, -1]],
    :horizontal => [[0, 1], [0, -1]],
    :vertical => [[1, 0], [-1, 0]]
  }

  def move_dirs(type)
    case type
    when :R
      DIRECTION[:horizontal] + DIRECTION[:vertical]
    when :B
      DIRECTION[:diagonal]
    when :Q
      DIRECTION[:diagonal] + DIRECTION[:horizontal] + DIRECTION[:vertical]
    end
  end

  def moves
    valid_moves = []
    possible_dirs = move_dirs(@type)

    possible_dirs.each do |dir|
      move = [dir[0] + @pos[0], dir[1] + @pos[1]]

      until valid?(move) == false
        valid_moves << move
        break if attack?(move)

        move = [move[0] + dir[0], move[1] + dir[1]]
      end
    end

    valid_moves
  end
end
