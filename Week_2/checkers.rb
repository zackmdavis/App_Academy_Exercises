require 'colorize'

class CheckersGame

end

class Checkerboard

  Checker = Struct.new("Checker", :color, :royalty)

  def initialize
    @board = Array.new(8){ Array.new(8) }
    (0..2).each do |row|
      (0..7).each do |col|
        if (row + col) % 2 == 1
          @board[row][col] = Checker.new(:black, false)
        end
      end
    end
    (5..7).each do |row|
      (0..7).each do |col|
        if (row + col) % 2 == 1
          @board[row][col] = Checker.new(:red, false)
        end
      end
    end
  end

  def at(position)
    @board[position[0]][position[1]]
  end

  def show
    (0..7).each do |row|
      (0..7).each do |col|
        unless at([row, col]).nil?
          if at([row, col]).color == :black
            print "\u2B24 ".colorize(:background => :cyan, :color => :black)
          elsif at([row, col]).color == :red
            print "\u2B24 ".colorize(:background => :cyan, :color => :light_red)
          end
        else
          if (row + col) % 2 == 1
            print "  ".colorize(:background => :cyan)
          else
            print "  ".colorize(:background => :white)
          end
        end
      end
      print "\n"
    end
  end

end

test_checkerboard = Checkerboard.new
test_checkerboard.show
