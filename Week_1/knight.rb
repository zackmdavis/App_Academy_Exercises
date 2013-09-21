class PositionNode
  attr_accessor :parent, :children
  attr_reader   :position

  def initialize(position)
    @position = position
    @parent = nil
    @children = []
  end
end

class KnightPathFinder
  attr_reader :move_tree, :root

  def initialize(origin)
    @root = PositionNode.new(origin)
    build_move_tree(@start)
  end

  def find_path(target)
    target_node = find_path_dfs(@root, target)
    path = [target_node]
    while path.last.parent != nil
      path.push(path.last.parent)
    end
    path.map{|node| node.position}.reverse
  end

  private

    def build_move_tree(origin)
      scanned = []
      to_scan = []
      to_scan.push(@root)
      until to_scan.empty?
        scanning = to_scan.shift
        scanning.children = KnightPathFinder.new_positions(scanning)
        scanning.children.each do |child|
          unless to_scan.find{|node| node.position == child.position} or scanned.find{|node| node.position == child.position}
            to_scan.push(child)
          end
        end
        scanned.push(scanning)
      end
    end

    def self.new_positions(node)
      offsets = [[1,2], [2,1], [-1,2], [-2,1], [1,-2], [2,-1], [-1,-2], [-2,-1]]
      new_positions = offsets.map{ |offset| [node.position[0]+offset[0], node.position[1]+offset[1]]}
      new_positions.select!{ |position| position[0] < 8 and position[1] < 8 }
      new_positions.select!{ |position| position[0] >= 0 and position[1] >= 0 }
      new_nodes = new_positions.map{|position| PositionNode.new(position)}
      new_nodes.each do |new_node|
        new_node.parent = node
      end
      new_nodes
    end

    def find_path_dfs(node, target)
      if node.children.empty?
        return nil
      elsif node.position == target
        return node
      end
      node.children.each do |child|
        search = find_path_dfs(child, target)
        return search if search
      end
      return nil
    end
end

board = KnightPathFinder.new([0,0])
p board.find_path([2,1])
p board.find_path([3,3])

# p KnightPathFinder.new_positions([0,0]).length