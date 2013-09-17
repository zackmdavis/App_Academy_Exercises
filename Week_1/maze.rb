
file = File.open(ARGV[0], "r")


class Maze
  def initialize(specs)
    @maze = []
    specs.lines do |line|
      @maze.push(line.chomp.chars)
    end
    @maze.each_index do |i|
      @maze[i].each_index do |j|
        if @maze[i][j] == 'S'
          @start = [i,j]
        elsif @maze[i][j] =='F'
          @finish = [i,j]
        end
      end
    end
  end

#  def display_start_finish
#    puts "Start is #{@start}"
#    puts "Finish is #{@finish}"
 # end

  def display
    @maze.each do |line|
      print line, "\n"
    end
  end


  def search
    @path = []
    closed = []
    open = []
  end

  def solve
    @solved = @maze.map(&:dup)
    # TODO
  end


end


our_maze = Maze.new(file)
our_maze.display
our_maze.display_start_finish