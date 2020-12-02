class Node

  attr_accessor :left, :right, :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree

  attr_accessor :root, :data

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

  # accepts a node and returns its height. Returns -1 if node doesn't exist
  # height: number of edges from a node to the lowest leaf in its subtree

  def height(node = root)
    unless node.nil? || node == root
      node = (node.class == Node ? find(node.data) : find(node))
    end

    return -1 if node.nil?
    return [height(node.left), height(node.right)].max + 1
  end

  # accepts a node and returns its depth. Returns -1 if node doesn't exist
  # depth: number of edges from the root to the given node

  def depth(node = root, parent = root, edges = 0)
    return 0 if node == parent
    return -1 if parent.nil?

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

  # checks if tree is balanced: the difference between the heights of left subtree 
  # and right subtree of every node is not more than 1

  def balanced?(node = root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)

    false
  end

  # balances an unbalanced tree

  def rebalance
    self.data = inorder_array
    self.root = build_tree(data)
  end

  # visualize binary search tree, method by student on Discord

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  # helper method that finds the leftmost leaf
  
  def leftmost_leaf(node)
    until node.left.nil?
      node = node.left
    end
    node
  end

  # create inorder array of tree
  
  def inorder_array(node = root, array = [])
    unless node.nil?
      inorder_array(node.left, array)
      array << node.data
      inorder_array(node.right, array)
    end
    array
  end
end

# Driver script

array = Array.new(15) { rand(1..100) }
bst = Tree.new(array)

bst.pretty_print

puts bst.balanced? ? "Your Binary Search Tree is balanced." : "Your Binary Search Tree is not balanced."

puts "Level order traversal: "
puts bst.level_order

puts "Preorder traversal: "
puts bst.preorder

puts "Inorder traversal: "
puts bst.inorder

puts "Postorder traversal: "
puts bst.postorder

10.times do
  a = rand(100..150)
  bst.insert(a)
  puts "Inserted #{a} to tree."
end

bst.pretty_print

puts bst.balanced? ? "Your Binary Search Tree is balanced." : "Your Binary Search Tree is not balanced."

puts "Rebalancig tree..."
bst.rebalance

bst.pretty_print

puts bst.balanced? ? "Your Binary Search Tree is balanced." : "Your Binary Search Tree is not balanced."

puts "Level order traversal: "
puts bst.level_order

puts "Preorder traversal: "
puts bst.preorder

puts "Inorder traversal: "
puts bst.inorder

puts "Postorder traversal: "
puts bst.postorder
