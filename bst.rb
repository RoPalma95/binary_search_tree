require 'pry'

module Comparable

  # compare nodes using their 'data' attributes

end

class Node
  include Comparable

  attr_accessor :left, :right, :data, :height

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
    @height = 0
  end
end

class Tree

  attr_reader :root, :data # attr_accessor ?

  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  # turns array into balanced bst full of 'Node' objects appropriately placed
  # returns the level-1 root node (array has to be sorted and without duplicates)

  def build_tree(array)
    return nil if array.empty?

    middle = (array.size - 1) / 2
    root_node = Node.new(array[middle])

    root_node.left = build_tree(array[0...middle])
    root_node.right = build_tree(array[(middle + 1)..-1])

    root_node
  end

  # accepts a value to insert, returns nil if value already exists

  def insert(value, node = root)
    return nil if value == node.data

    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  # accepts a value to delete

  def delete(value, node = root)
    return node if node.nil?

    if value < node.data 
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      # if node has one or no child
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      #if node has two children
      leftmost_node = leftmost_leaf(node.right)
      node.data = leftmost_node.data
      node.right = delete(leftmost_node.data, node.right)
    end
    node
  end

  # helper method that finds the leftmost leaf
  
  def leftmost_leaf(node)
    until node.left.nil?
      node = node.left
    end
    node
  end

  # returns the node with the given value, returns nil if node is not found

  def find(value, node = root)
    return node if node.nil? || node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  # # returns an array of values traversing the tree breadth-first

  def level_order(node = root, queue = [])
    print "#{node.data} "
    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?
    return nil if queue.empty?
    level_order(queue.shift, queue)
  end

  # the following 3 methods return an array of values, traversing the tree
  # in their respective depth-first order

  def preorder(node = root)
    # Root Left Right
    unless node.nil?
      print "#{node.data} "
      preorder(node.left)
      preorder(node.right)
    end
  end

  def inorder(node = root)
    # Left Root Right
    unless node.nil?
      inorder(node.left)
      print "#{node.data} "
      inorder(node.right)
    end
  end

  def postorder(node = root)
    # Left Right Root
    unless node.nil?
      postorder(node.left)
      postorder(node.right)
      print "#{node.data} "
    end
  end

  # accepts a node and returns its height, also sets the height for each node
  # height: number of edges from a node to the lowest leaf in its subtree

  def height(node = root)
    
    node = find(node) unless node.nil? || node.class == Node

    unless node.nil?
      height(node.left)
      height(node.right)
      unless node.left.nil? && node.right.nil?
        node.height = (node.left.nil? ? node.right.height + 1 : node.left.height + 1)
      end
    end

    return node.nil? ? nil : node.height
  end

  # accepts a node and returns its depth
  # depth: number of edges from the root to the given node

  def depth(node = root, parent = root, edges = 0)
    return 0 if node == parent
    
    if node < parent.data
      edges += 1
      depth(node, parent.left, edges)
    elsif node > parent.data
      edges += 1
      depth(node, parent.right, edges)
    else
      edges
    end
  end

  # # checks if tree is balanced: the difference between the heights of left subtree 
  # # and right subtree of every node is not more than 1

  # def balanced?
  # end

  # # balances an unbalanced tree

  # def rebalance
  # end
end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(array)
puts tree.height
binding.pry
tree.root

