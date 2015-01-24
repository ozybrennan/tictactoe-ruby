require 'byebug'

class PolyTreeNode
  attr_accessor :parent, :value, :children

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent
    @parent
  end

  def children
    @children
  end

  def value
    @value
  end

  def parent=(parent)
    unless @parent == nil
      @parent.children.delete(self)
    end
    @parent = parent
    unless parent == nil || parent.children.include?(self)
      parent.children << self
    end
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    raise "Not a child!" if child_node.parent != self
    child_node.parent = nil
  end

  def dfs(target_value)
    return self if @value == target_value

    @children.each do |child|
      node = child.dfs(target_value)
      return node unless node.nil?
    end

    nil

  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      node = queue.shift
      if node.value == target_value
        return node
      else
        node.children.each do |child|
          queue.push(child)
        end
      end
    end
  end

  def trace_path_back
    return [@value] if @parent.nil?
    @parent.trace_path_back + [@value]
  end

end

class KnightPathFinder
  attr_reader :position, :visited_positions, :all_move_array

  def initialize(position)
    @position = position
    @visited_positions = [position]
    @move_tree = build_move_tree
  end

  def self.valid_moves(position)
    row, column = position
    empty_spots = []
    offsets = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
    offsets.each do |offset|
      new_pos = [row + offset.first, column + offset.last]
      unless new_pos[0] > 7 || new_pos[0] < 0 || new_pos[1] > 7 || new_pos[1] < 0
        empty_spots << new_pos
      end
    end
    empty_spots
  end

  def new_move_positions(pos)
    move_array = KnightPathFinder.valid_moves(pos)
    move_array -= @visited_positions
    @visited_positions += move_array
    move_array
  end

  def build_move_tree
    root_position = PolyTreeNode.new(@position)
    positions_queue = [root_position]
    until positions_queue.empty?
      position = positions_queue.shift
      new_positions = new_move_positions(position.value)
      new_positions.each do |new_position|
        node = PolyTreeNode.new(new_position)
        node.parent = position
        positions_queue.push(node)
      end
    end
    # p root_position.children
    root_position
  end

  def find_path(end_pos)
    @move_tree.dfs(end_pos).trace_path_back
  end

end

k1 = KnightPathFinder.new([0,0])
p k1.find_path([7, 6])
p k1.find_path([6, 2])
