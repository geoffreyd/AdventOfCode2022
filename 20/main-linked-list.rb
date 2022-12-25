# frozen_string_literal: true

require 'debug'
require 'set'
require 'linked-list'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

class Node
  attr_accessor :value, :next_node, :prev_node, :prev_orig, :is_first
  attr_reader :next_orig, :orig_first

  def initialize(value, prev_node = nil, next_node = nil)
    @value = value
    @next_node = @next_orig = next_node
    @prev_node = @prev_orig = prev_node
    @is_first = false
    @orig_first = false
  end

  def next_orig=(node)
    @next_orig = node
    @next_node = node
  end

  def orig_first=(value)
    @is_first = value
    @orig_first = value
  end
end

def print_nodes(node)
  node = node.prev_node until node.is_first

  while node
    print "#{node.value}, "
    node = node.next_node
    if node.is_first
      puts
      break
    end
  end
  puts
end

def remove_from_linked_list(node)
  if node.is_first
    node.next_node.is_first = true
    node.is_first = false
    # puts "New First node: #{node.next_node.value}, old first node: #{node.value}"
  end
  node.prev_node.next_node = node.next_node
  node.next_node.prev_node = node.prev_node
end

def inject_into_linked_list(node, prev_node)

  node.prev_node = prev_node
  node.next_node = prev_node.next_node
  prev_node.next_node.prev_node = node
  prev_node.next_node = node
  # calim first node if needed
  # if node.next_node.is_first
  #   node.is_first = true
  #   node.next_node.is_first = false
  #   puts "New first Node: #{node.value}, old first node: #{node.next_node.value}"
  # end
end

nodes = []
first_node = nil
lines.each.with_index do |line, i|
  nodes[i] = Node.new(line.to_i, nodes[i - 1])
  nodes[i - 1].next_orig = nodes[i] if i > 0
  if i == 0
    first_node = nodes[i]
    first_node.is_first = true
  end
end
@node_count = nodes.size
nodes.last.next_node = first_node
first_node.prev_node = nodes.last

node = nodes[0]
puts "Start"
# print_nodes(node)

while node
  # puts "Move #{node.value}, prev: #{node.prev_node.value}, next: #{node.next_node.value}"
  value = node.value
  if value > @node_count
    value = value % @node_count
  end
  if value != 0
    remove_from_linked_list(node)
    # find node that is value distance away
    next_node = node
    if value > 0 # clockwise
      value.times do
        next_node = next_node.next_node
      end
    else # counter-clockwise
      (value.abs + 1).times do
        next_node = next_node.prev_node
      end
    end
    inject_into_linked_list(node, next_node)
  end
  # puts "End move #{node.value}, prev: #{node.prev_node.value}, next: #{node.next_node.value}"
  node = node.next_orig
  # print_nodes(node || first_node)
end

# find values at positions 1000, 2000, and 3000
# indexes = [1000, 2000, 3000]

current_node = first_node
current_node = current_node.next_node until current_node.value == 0
current_node = current_node.next_node
values = []
(1..3000).each do |i|
  if i % 1000 == 0
    puts "Value at #{i}: #{current_node.value}, prev: #{current_node.prev_node.value}, next: #{current_node.next_node.value}"
    values << current_node.value
  end
  current_node = current_node.next_node
end

puts "Values: #{values}"
puts "Sum: #{values.sum}"
