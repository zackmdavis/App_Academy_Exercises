class Minesweeper

  def initialize
    setup
    play
  end

  def setup
    @board = MineBoard.new(9, 9, 10)

  end

  def play

  end

end

class MineBoard

  def initialize(length, width, mine_count)
    @length = length
    @width = width
    @mine_count = mine_count
    @minefield = [['e']*length]*width
    populate_minefield
  end

  def populate_minefield
    mine_locations = []
    until mine_locations.length == @mine_count do
      candidate_location = [rand(0...width), rand(0...length)]
      unless mine_locations.include?(candidate_location)
        mine_locations.push(candidate_location)
      end
    end
    (0...@width).each do |i|
      (0...@length).each do |j|
        minefield Tile.new(i, j, self)


  def show
    (0...@width).each do |i|
      (0...@length).each do |j|
        #case at(x, y)
        #when
        # flag symbol for flags? "\u2691"
        # radioactive symbol for mines?? "\u2622"
      end
    end
  end

  def at(x, y)

end


class Tile

  attr_reader :x, :y, :mine

  def initialize(x, y, board)
    @x = x
    @y = y
    @board = board
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

  def set_mine
    @mine = true
  end

  def mine?
    @mine
  end

end

