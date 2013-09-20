class PositionNode
  attr_accessor :parent, :children

  def initialize(position)
    @position = position
    @parent = nil
    @children = []
  end
end


class KnightPathFinder
  attr_accessor :move_tree

  def initialize(origin)
    @start = origin
    build_move_tree(@start)
  end

  def build_move_tree(origin)
    root = PositionNode.new(root)
    root.children = KnightPathFinder.new_positions(origin)
    ## build the tree
  end

  def self.new_positions(position)
    offsets = [[1,2], [2,1], [-1,2], [-2,1], [1,-2], [2,-1], [-1,-2], [-2,-1]]
    new_positions = offsets.map{ |offset| [position[0]+offset[0], position[1]+offset[1]]}
    new_positions.select!{ |position| position[0] < 8 and position[1] < 8 }
    new_positions.select!{ |position| position[0] >= 0 and position[1] >= 0 }
    new_positions.map!{|position| PositionNode.new(position)}
  end

  def find_path

  end

end