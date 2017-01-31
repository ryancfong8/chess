require "io/console"

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end

  def handle_key(key)
    case key
    when :return #{"\r" || " "}
      key = @cursor_pos
    when :left #{"h" || "a" || "\e[D"}
      update_pos(MOVES[:left])
      nil
    when :right #{"l" || "d" || "\e[C"}
      update_pos(MOVES[:right])
      nil
    when :up #{"\e[A" || "k" || "w"}
      update_pos(MOVES[:up])
      nil
    when :down #{"\e[B" || "j" || "s"}
      update_pos(MOVES[:down])
      nil
    when :ctrl_c #{"\u0003"}
      Process.exit(0)
    end
  end

  def update_pos(diff)
    case diff
    when MOVES[:left]
      new_pos = [@cursor_pos[0], @cursor_pos[1] - 1]
      @cursor_pos[1] -= 1 if in_bounds?(new_pos)
      # handle error if not
    when MOVES[:right]
      new_pos = [@cursor_pos[0], @cursor_pos[1] + 1]
      @cursor_pos[1] += 1 if in_bounds?(new_pos)
    when MOVES[:up]
      new_pos = [@cursor_pos[0] - 1, @cursor_pos[1]]
      @cursor_pos[0] -= 1 if in_bounds?(new_pos)
    when MOVES[:down]
      new_pos = [@cursor_pos[0] + 1, @cursor_pos[1]]
      @cursor_pos[0] += 1 if in_bounds?(new_pos)
    end
  end

  def in_bounds?(pos)
    row, col = pos
    return true if row.between?(0,8) && col.between?(0,8)
    false
  end
end
