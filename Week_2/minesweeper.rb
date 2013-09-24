require 'ostruct'
require 'yaml'

# This class represents the Minesweeper game.
class Minesweeper

  DEFAULT_GAME_ROWS = 12
  DEFAULT_GAME_COLS = 12
  DEFAULT_MINES = 10
  SAVE_FILE = 'saved_game.yaml'

  def initialize

    setup
    play
  end

  def setup
    @quit_requested = false

    rows = DEFAULT_GAME_ROWS
    cols = DEFAULT_GAME_COLS
    mines = DEFAULT_MINES

    puts "Welcome to Minesweeper"
    puts "Current settings: size: #{rows}, #{cols}, mines: #{mines}"
    puts "enter 'n' to start a new game, 's' to change size/mine settings, 'l' to load a saved game"
    setup_input = gets.chomp

    case setup_input
    when 'n'
      @board = MineBoard.new(rows, cols, mines)
    when 's'
      rows, cols, mines = get_settings
      @board = MineBoard.new(rows, cols,mines)
    when 'l'
      @board = YAML::load(File.open(SAVE_FILE, 'r'))
    else
      setup
    end
    puts "(note: you can save your game with 's' or quit with 'q')"
  end

  def get_settings
    puts "enter new settings like 'rows,columns,number_of_mines'"
    settings_input = gets.chomp
    settings_input.split(',').map(&:to_i)
  end

  def get_move
    print "Please enter move ('f row,col' to flag; 'row,col' to explore): "
    move_string = gets.chomp
    move = OpenStruct.new

    case move_string[0]
    when 'f'
      move.flag = true
      move_string = move_string[2..-1]
    when 's'
      File.open(SAVE_FILE, 'w').write(YAML::dump(@board))
      return nil
    when 'q'
      @quit_requested = true
      return nil
    else
      move.flag = false
    end

    move.coordinates = move_string.split(',').map(&:to_i)
    move
  end

  def play
    until game_over || @quit_requested do
      @board.show
      move = get_move
      if move
        if move.flag
          @board.flag(move.coordinates)
        else
          @board.explore(move.coordinates)
        end
      end
    end
    @board.show
  end

  def game_over
    if(@board.won?)
      puts "good job"
      true
    elsif(@board.boom?)
      puts "ouch"
      true
    else
      false
    end
  end
end

class MineBoard

  def initialize(height, width, mine_count)
    @height = height
    @width = width
    @mine_count = mine_count
    @minefield = []
    @mines = []
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
        new_tile = Tile.new([row, col], self)
        if(mine_locations.include?([row, col]))
          new_tile.set_mine
          @mines << new_tile
        end
        @minefield[row] << new_tile

      end
    end
  end

  def col_indices
    top = "  "
    bottom = "    "
    @width.times do |col_index|
      if(col_index < 10)
        top << "  "
        bottom << "#{col_index} "
      else
        top << "#{col_index/10} "
        bottom << "#{col_index %10} "
      end
    end
    "#{top}\n#{bottom}"
  end

  def show
    print "  "

    puts col_indices
    @minefield.each_with_index do |row, row_index|
      index_string = row_index.to_s
      spacer = index_string.length == 1? "  " : " "
      print spacer, row_index, " "
      row.each do |tile|
        if tile.flag?
          print "\u2691 " # flag icon
        elsif tile.explored?
          if tile.boom?
            print "\u2622 " # radioactivity symbol
          elsif tile.number != 0
            print tile.number,  " "
          elsif tile.number == 0
            print "  "
          end
        else
          print "\u25A0 " # filled-in square
        end
      end
      print "\n"
    end
  end

  def explore(coordinates)
    @minefield[coordinates[0]][coordinates[1]].explore
  end

  def flag(coordinates)
    @minefield[coordinates[0]][coordinates[1]].flag = !@minefield[coordinates[0]][coordinates[1]].flag
  end

  def find_tile(coordinates)
    @minefield[coordinates[0]][coordinates[1]]
  end

  def in_bounds?(coordinates)
    coordinates[0].between?(0, @height-1) and coordinates[1].between?(0, @width-1)
  end

  def won?
    mines = @minefield.flatten.select{|tile|tile.mine?}
    mines_flagged = @mines.all?(&:flag?)
    non_mines = @minefield.flatten.reject(&:mine?)
    non_mines_explored = non_mines.all?(&:explored?)
    mines_flagged && non_mines_explored
  end

  def boom?
    @mines.any?(&:explored?)
  end

end


class Tile

  attr_accessor :flag
  attr_reader :location, :number

  def initialize(coordinates, board)
    @location = coordinates
    @board = board
    @explored = false
    @flag = false
    @number = nil
  end

  def neighborhood
    neighbors = []
    (-1..1).each do |row_offset|
      (-1..1).each do |col_offset|
        next if row_offset == 0 and col_offset == 0
        neighbor_coordinates = [self.location[0]+row_offset, self.location[1]+col_offset]
        next unless @board.in_bounds?(neighbor_coordinates)
        neighbors.push(@board.find_tile(neighbor_coordinates))
      end
    end
    neighbors.compact
  end

  def explore
    #if mine, explode set to mine char, board knows game is over
    #else find number
    #call explore in BFS fashion on all unexplored neighbors
    #if NO mines in neighbors, explore all neighbors
    @explored = true
    unless boom?
      neighbors = neighborhood
      @number = neighbors.select{|tile|tile.mine?}.count
      if @number.zero?
        unexplored_neighbors = neighbors.reject{ |tile| tile.explored? }
        unexplored_neighbors.each(&:explore)
      end

    end

  end

  def set_mine
    @mine = true
  end

  def mine?
    @mine
  end

  def boom?
    @mine && @explored
  end

  def explored?
    @explored
  end

  def flag?
    @flag
  end


end

Minesweeper.new