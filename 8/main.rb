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

## Part 2

def scenic_score(height, heights)
  return 0 if heights.empty?

  lower = heights.index { |h| h >= height }
  return heights.length if lower.nil?

  lower + 1
end

# For each number in the grid count the number of positivly incrementing numbers in each direction
scenic_scores = grid.map.with_index do |row, y|
  row.map.with_index do |number, x|
    scores = [
      # up
      scenic_score(number, (0...y).map { |i| grid[i][x] }.reverse),
      # left
      scenic_score(number, (0...x).map { |i| grid[y][i] }.reverse),
      # down
      scenic_score(number, (y + 1...height).map { |i| grid[i][x] }),
      # right
      scenic_score(number, (x + 1...width).map { |i| grid[y][i] })
    ]

    score = scores.inject(:*)

    if score.positive?
      pp "x: #{x}, y: #{y}, num: #{number}, score: #{score}"
      pp scores
    end

    score
  end
end

# print a table of the scores
scenic_scores.each do |row|
  puts row.map { |s| s.to_s.rjust(4, ' ') }.join(' ')
end

pp scenic_scores.flatten.max
