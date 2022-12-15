# frozen_string_literal: true
require 'json'
require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

@grid = {}

y_to_check = 2000000
scanned_points = []

lines.each do |line|
  # extract the data from lines that look like this:
  # Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  s_x, s_y, b_x, b_y = line.scan(/-?\d+/).map(&:to_i)
  manhattan_distance = (s_x - b_x).abs + (s_y - b_y).abs
  puts "Found details: #{s_x}, #{s_y}, #{b_x}, #{b_y}, #{manhattan_distance}"
  @grid[[s_x, s_y]] = manhattan_distance
  @grid[[b_x, b_y]] = true

  (s_x - manhattan_distance..s_x + manhattan_distance).each do |x|
    # if x, y_to_check is within manhattan_distance of s_x, s_y
    # then it's a valid point
    puts "Checking #{x}, #{y_to_check}: #{(x - s_x).abs + (y_to_check - s_y).abs <= manhattan_distance}" if [s_x, s_y] == [20, 14]
    if (x - s_x).abs + (y_to_check - s_y).abs <= manhattan_distance
      scanned_points << [x, y_to_check]
    end
  end
end

points = scanned_points - @grid.keys

puts "Points: #{points.uniq.sort}"
puts "Answer: #{points.uniq.count}"

# min_y, max_y = @grid.keys.map(&:last).minmax
# min_x, max_x = @grid.keys.map(&:first).minmax

# (min_x..max_x).each do |x|

# end

