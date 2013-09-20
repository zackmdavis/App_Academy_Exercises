class BinaryTreeNode

  attr_accessor :parent, :value
  attr_reader :left, :right

  def initialize(value)
    @value = value
    @parent = nil
    @left = nil
    @right = nil
  end

  def inspect
    print "Value: #{@value}, parent: #{@parent ? @parent.value : "None"}, " +
      "left: #{@left ? @left.value : "None"}, right: #{@right ? @right.value : "None"}"
  end

  def left=(left_child)
    if @left
      @left.parent = nil
    end
    left_child.parent = self
    @left = left_child
  end

  def right=(right_child)
    if @right
      @right.parent = nil
    end
    right_child.parent = self
    @right = right_child
  end

  def self.depth_first_search(node, target)
    if node.nil?
      return nil
    elsif node.value == target
      return node
    else
      [node.left, node.right].each do |child|
        search = depth_first_search(child, target)
        return search if search
      end
      return nil
    end
  end

  def breadth_first_search(target)
    to_scan = [self]
    until to_scan.empty?
      scanning = to_scan.shift
      value = scanning.value
      if value == target
        return scanning
      else
        to_scan.push(scanning.left) if scanning.left
        to_scan.push(scanning.right) if scanning.right
      end
    end
    return nil
  end
end

class TreeNode

  attr_accessor :parent, :value
  attr_reader :children

  def initialize(value)
    raise ArgumentError if value.nil?
    @value = value
    @parent = nil
    @children = []
  end

  def inspect
    print "Value: #{@value}, parent: #{@parent ? @parent.value : "None"}, Children: "
    if @children.empty?
      print "None"
    else
      @children.each do |child|
        print "#{child.value} "
      end
    end

  end

  def add_child(node)
    node.parent = self
    @children.push(node)
  end

  def remove_child(node)
    node.parent = nil
    @children.delete(node)
  end

  def self.depth_first_search(node, target = nil, &prc)
    if node.nil?
      return nil
    elsif node.value == target
      return node
    elsif block_given?
      if yield(node.value)
        return node
      end
    end
    node.children.each do |child|
      search = depth_first_search(child, target, &prc)
      return search if search
    end
    return nil
  end

  def breadth_first_search(target = nil)
    to_scan = [self]
    if block_given?
      until to_scan.empty?
        scanning = to_scan.shift
        value = scanning.value
        if yield(value)
          return scanning
        end
        to_scan += scanning.children
      end
    else
      until to_scan.empty?
        scanning = to_scan.shift
        value = scanning.value
        if value == target
          return scanning
        end
        to_scan += scanning.children
      end
    end
    return nil
  end
end