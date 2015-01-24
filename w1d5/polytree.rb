class PolyTreeNode
  attr_accessor :parent :value :children

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
    @parent = parent
    parent.children << @value
  end

end
