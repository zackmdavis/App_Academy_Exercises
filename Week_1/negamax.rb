# This class represents a node in a game tree for use by AI players.
class GametreeNode

  attr_accessor :value, :parent, :children
  attr_reader   :state, :turn

  def initialize(turn, value = nil, parent = nil, children = nil)
    @turn = turn
    @value = value
    @parent = parent
    @children = children
  end

  def add_children(new_children)
    if @chilren.nil?
      @children = []
    end
    new_children.each do |new_child|
      new_child.parent = self
      @children.push(new_child)
    end
  end

  # Minimax search down from this node.
  def negamax_search
    if @value
      return @value
    else
      @children.each{ |child| child.negamax_search }
      if turn == 0 # first player maximizing
        @value = @children.map{ |child| child.value }.max
      elsif turn == 1 # second player minimizing
        @value = @children.map{ |child| child.value }.min
      end
    end
    return @value
  end

end

# Let's see if I can get my code to reproduce the
# gametree at http://en.wikipedia.org/wiki/File:Minimax.svg
#           -7
#      -10        -7
#  10    -10    5     -7
# 10 5  -10   5 -Inf  -7
#
root = GametreeNode.new(0)
level_one = [GametreeNode.new(1), GametreeNode.new(1)]
level_two_A = [GametreeNode.new(0), GametreeNode.new(0)]
level_two_B =  [GametreeNode.new(0), GametreeNode.new(1)]
level_three_A = [GametreeNode.new(1, 10), GametreeNode.new(1, 5)]
level_three_B = [GametreeNode.new(1, -10)]
level_three_C = [GametreeNode.new(1, 5), GametreeNode.new(1, -9999)]
level_three_D = [GametreeNode.new(1, -7)]

root.add_children(level_one)
level_one[0].add_children(level_two_A)
level_one[1].add_children(level_two_B)
level_two_A[0].add_children(level_three_A)
level_two_A[1].add_children(level_three_B)
level_two_B[0].add_children(level_three_C)
level_two_B[1].add_children(level_three_D)

root.negamax_search

p root.value
p root.children.map{|node| node.value}
print root.children[0].children.map{|node| node.value}, root.children[1].children.map{|node| node.value}