require_relative 'board'
require_relative 'cursor'
require 'colorize'

require 'byebug'

class Display

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)

    @board.populate
  end

  def render
    puts "   #{(0...8).to_a.join("  ")}"
    @board.grid.each_with_index do |row, index|
      print "#{index}: "
      row.each_with_index do |pos, i|
        if [index, i] == @cursor.cursor_pos
          print "#{pos.type}  ".colorize(:background => :magenta)
        elsif i == row.length - 1
          print "#{pos.type} \n"
        else
          print "#{pos.type}  "
        end
      end
    end
    '^^ sweet board'
  end

  def move_cursor
    15.times do
      render
      @cursor.get_input
    end
  end
end
