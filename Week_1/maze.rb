
file = File.open(ARGV[0], "r")


class Node
  :attr_reader f, g
  :attr_accessor coord, parent, h

  def initialize(coord, parent, finish)
    @coord = coord
    @parent = parent
    @g = parent.g + 1
    @h = (finish[0]-here[0]).abs + (finish[1]-here[1]).abs
    @f = @g + @h
  end

  def g=(new_g)
    @g = new_g
    @f = @g + @h
  end
end

class Maze
  def initialize(specs)
    @maze = []
    specs.lines do |line|
      @maze.push(line.chomp.chars)
    end
    @maze.each_index do |i|
      @maze[i].each_index do |j|
        if @maze[i][j] =='F'
          @finish = Node.new([i,j], nil, [i,j])
        end
      end
    end
    @maze.each_index do |i|
      @maze[i].each_index do |j|
        if @maze[i][j] =='S'
          @start = Node.new([i,j], nil, @finish.coord)
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

#  {[i,j] => {:parent => [i,j], :g => score}

def adjacents(coord)
  adjacents = []
  (-1..1).each do |i|
    (-1..1).each do |j|
      unless i == 0 and j == 0
        adjacents << [coord[0]+i, coord[1]+j]
      end
    end
  end
  adjacents
end

def find_in(set, coord)
  set.find{|node| node.coord == coord}
end

def search
  closed = []
  open = [@start]
  while !open.empty?
    open.sort_by!{|node| node.f}
    current = open.shift
    closed << current
    adjacents(current).each do |adj|
      if adj == @finish
        find_path(closed, current)
      elsif find_in(close, adj)
        puts "already in closed"
      elsif find_in(open, adj)
        adj_node = find_in(open, adj)
        if adj_node.g > current.g + 1
          adj_node.parent = current
          adj_node.g = current.g + 1 # also recomputes adj_node.f as side effect
      else
        if @maze[adj[0]][adj[1]] == ' '
          open << Node.new(adj, current, @finish)
        end
      end
    end
  end
end

def find_path(nodes, penultimate)
  path = [penultimate]
  while path.last.parent != nil
    # TODO
end


our_maze = Maze.new(file)
our_maze.display
our_maze.display_start_finish