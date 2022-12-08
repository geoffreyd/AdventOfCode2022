# frozen_string_literal: true

require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

# read lines in as a grid of single digits
grid = lines.map { |line| line.split('').map(&:to_i) }

height = grid.length
width = grid[0].length

visibility = grid.map.with_index do |row, y|
  row.map.with_index do |number, x|
    next 1 if x.zero? || x == width - 1 || y.zero? || y == height - 1

    # right
    visible = (x + 1...width).all? { |i| grid[y][i] < number }
    # left
    visible ||= (0...x).all? { |i| grid[y][i] < number }
    # down
    visible ||= (y + 1...height).all? { |i| grid[i][x] < number }
    # up
    visible ||= (0...y).all? { |i| grid[i][x] < number }

    visible ? 1 : 0
  end
end

pp visibility

visible_count = visibility.flatten.count(1)

pp visible_count
