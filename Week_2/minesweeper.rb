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

  private

  def setup
    @quit_requested = false

    rows = DEFAULT_GAME_ROWS
    cols = DEFAULT_GAME_COLS
    mines = DEFAULT_MINES

    puts "Welcome to Minesweeper"
    puts "Current settings: size: #{rows}, #{cols}, mines: #{mines}"
    puts "enter 'n' to start a new game, 's' to change size/mine settings, 'l' to load a saved game"
    setup_input = get_char

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

  def get_char
    # Thanks to http://stackoverflow.com/questions/8142901/ruby-stdin-getc-does-not-read-char-on-reception
    begin
      system("stty raw -echo")
      str = STDIN.getc
    ensure
      system("stty -raw echo")
    end
    str.chr
  end

  def get_settings
    puts "enter new settings like 'rows,columns,number_of_mines'"
    settings_input = gets.chomp
    settings_input.split(',').map(&:to_i)
  end

  def get_move
    print "Use i,j,k,l to steer the cursor. Space to explore. 'f' to flag."
    command = get_char

    move = OpenStruct.new
    move.flag = false
    case command
    when ' '
    when 'f'
      move.flag = true
    when 's'
      File.open(SAVE_FILE, 'w').write(YAML::dump(@board))
      return nil
    when 'q'
      @quit_requested = true
      return nil
    else
      @board.move_cursor(command)
      return nil
    end

    move.coordinates = @board.cursor_location
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
  attr_reader :cursor_location

  def initialize(height, width, mine_count)
    @height = height
    @width = width
    @mine_count = mine_count
    @minefield = []
    @cursor_location = [0,0]
    populate_minefield
  end

  def show
    print "  "

    puts col_indices
    @minefield.each_with_index do |row, row_index|
      index_string = row_index.to_s
      spacer = index_string.length == 1? "  " : " "
      print spacer, row_index, " "
      row.each do |tile|
        if tile.location == @cursor_location
          print "\u2591 " # light shaded block
        elsif tile.flag?
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

  def move_cursor(command_key)
    new_location = @cursor_location.dup
    case command_key
    when 'i'
      new_location[0] -= 1
    when 'j'
      new_location[1] -= 1
    when 'k'
      new_location[0] += 1
    when 'l'
      new_location[1] += 1
    end
    if self.in_bounds?(new_location)
      @cursor_location = new_location
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
    mines = @minefield.flatten.select{ |tile| tile.mine? }
    mines_flagged = mines.all?(&:flag?)
    non_mines = @minefield.flatten.reject(&:mine?)
    non_mines_explored = non_mines.all?(&:explored?)
    mines_flagged && non_mines_explored
  end

  def boom?
    mines = @minefield.flatten.select{ |tile| tile.mine? }
    mines.any?(&:explored?)
  end

  private

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