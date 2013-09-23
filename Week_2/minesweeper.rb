require 'ostruct'

class Minesweeper

  def initialize
    setup
    play
  end

  def setup
    @board = MineBoard.new(9, 9, 10)

  end

  def get_move
    print "Please enter move ('f row,col' to flag, else 'row,col'): "
    move_string = gets.chomp
    move = OpenStruct.new

    if move_string[0] == 'f'
      move.flag = true
      move_string = move_string[2..-1]
    else
      move.flag = false
    end

    move.coordinates = move_string.split(',').map(&:to_i)
    move
  end

  def play
    until game_over? do
      @board.show
      move = get_move
      if move.flag
        @board.flag(move.coordinates)
      else
        @board.explore(move.coordinates)
      end

    end
  end

  def game_over?

  end

end

class MineBoard

  def initialize(height, width, mine_count)
    @height = height
    @width = width
    @mine_count = mine_count
    @minefield = []
    populate_minefield
  end

  def populate_minefield
    mine_locations = []
    until mine_locations.count == @mine_count do
      candidate_location = [rand(0...@width), rand(0...@height)]
      unless mine_locations.include?(candidate_location)
        mine_locations.push(candidate_location)
      end
    end

    (0...@height).each do |row|
      @minefield << []
      (0...@width).each do |col|
        #put in mines
        new_tile = Tile.new(row, col, self)
        if(mine_locations.include?([row, col]))
          new_tile.set_mine
        end
        @minefield[row] << new_tile
      end
    end
  end

  def show
    @minefield.each do |row|
      row.each do |tile|
        if tile.flag
          print "\u2691 " # flag icon
        elsif tile.explored
          if tile.number != 0
            print tile.number
          else
            print " "
          end
        else
          print "\u25A0 " # full block
        end
      end
      print "\n"
    end
  end

  def explore(coordinates)
  end

  def flag(coordinates)
    @minefield[coordinates[0]][coordinates[1]].flag = true
  end

end


class Tile

  attr_reader :row, :col, :mine, :explored
  attr_accessor :flag

  def initialize(row, col, board)
    @row = row
    @col = col
    @board = board
    @explored = false
    @flag = false
  end

  def neighborhood
    neighbors = []
    (-1..1).each do |i|
      (-1..1).each do |j|
        unless i == 0 and j == 0
          neighbors.push(board.at(i, j))
        end
      end
    end
    neighbors.compact
  end

  def number
    # actual logic goes here
    return false
  end

  def explore
    ####....
    @explored = true
  end

  def set_mine
    @mine = true
  end

  def mine?
    @mine
  end

end

Minesweeper.new