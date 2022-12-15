# frozen_string_literal: true

require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

@grid = {}

lower_bounds = 0
upper_bounds = 4_000_000
# scanned_points = []

lines.each do |line|
  # extract the data from lines that look like this:
  # Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  s_x, s_y, b_x, b_y = line.scan(/-?\d+/).map(&:to_i)
  manhattan_distance = (s_x - b_x).abs + (s_y - b_y).abs
  # puts "Found details: #{s_x}, #{s_y}, #{b_x}, #{b_y}, #{manhattan_distance}"
  @grid[[s_x, s_y]] = manhattan_distance
  # @grid[[b_x, b_y]] = true
end

# points = scanned_points - @grid.keys

# puts "Points: #{points.uniq.sort}"
# puts "Answer: #{points.uniq.count}"

scanner_points = @grid.keys

def border_points(point, distance)
  distance += 1
  x, y = point
  boundary_coordinates = []
  (-distance..distance).each do |x_offset|
    # puts "Rendering offset: #{x_offset} x: #{x + x_offset}, y: #{y + distance + x_offset}"
    boundary_coordinates << [x + x_offset, y - (distance - x_offset.abs)]
    boundary_coordinates << [x + x_offset, y + (distance - x_offset.abs)]
  end
  boundary_coordinates.uniq
end

found = nil
# checked = Set.new

scanner_points.each_index do |i|
  break if found

  # for each point around the border of this scanners manhattan distance
  # If there is another scanner in distance, move on.
  # If there is no other scanner in distance, this is our point.
  s_x, s_y = scanner_points[i]
  manhattan_distance = @grid[[s_x, s_y]]
  puts "Checking Scanner #{i} with distance #{manhattan_distance}"

  possible_overlaps = scanner_points.reject do |scanner_point|
    other_scanner_distance = @grid[scanner_point]
    distance_between_scanners = (scanner_point[0] - s_x).abs + (scanner_point[1] - s_y).abs

    distance_between_scanners > manhattan_distance + other_scanner_distance + 1 ||
      manhattan_distance > distance_between_scanners + other_scanner_distance ||
      distance_between_scanners + manhattan_distance < other_scanner_distance
  end

  border_points([s_x, s_y], manhattan_distance).each do |point|
    x, y = point
    next if x < lower_bounds || x > upper_bounds || y < lower_bounds || y > upper_bounds

    # puts "Checking border point: #{point}"
    next if possible_overlaps.any? do |scanner_point|
      (scanner_point[0] - x).abs + (scanner_point[1] - y).abs <= @grid[scanner_point]
    end

    found = point
    break
  end
end

pp found

pp (found[0] * upper_bounds) + found[1]
