# frozen_string_literal: true

require 'debug'
require 'set'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

cube = {}

@side_offsets = [
  [0,0,1],
  [0,0,-1],
  [0,1,0],
  [0,-1,0],
  [1,0,0],
  [-1,0,0]
]

lines.each do |line|
  x,y,z = line.split(',').map(&:to_i).map { _1 + 1 }

  cube[[x,y,z]] = 6

  # puts "=== Checking cube at #{x},#{y},#{z} ==="
  # for all sides of the cube, check for neighbors
  @side_offsets.each do |dx,dy,dz|
    next if dx == 0 && dy == 0 && dz == 0
    unless cube[[x+dx,y+dy,z+dz]].nil?
      # puts "Touching #{x+dx},#{y+dy},#{z+dz}. Reducing to #{cube[[x,y,z]] - 1}, #{cube[[x+dx,y+dy,z+dz]] - 1}"
      cube[[x,y,z]] -= 1
      cube[[x+dx,y+dy,z+dz]] -= 1
    end
  end
end

# pp cube

surface_area = cube.values.sum
print "Part 1: "
pp surface_area

# Part 2
pp 'Part 2'
# Remove individual cubes

minx, maxx = cube.keys.map { |x,_,_| x }.minmax
miny, maxy = cube.keys.map { |_,y,_| y }.minmax
minz, maxz = cube.keys.map { |_,_,z| z }.minmax
puts "minx: #{minx}, maxx: #{maxx}, miny: #{miny}, maxy: #{maxy}, minz: #{minz}, maxz: #{maxz}"

minx -= 1
maxx += 1
miny -= 1
maxy += 1
minz -= 1
maxz += 1

puts "Finding surface area"
puts "minx: #{minx}, maxx: #{maxx}, miny: #{miny}, maxy: #{maxy}, minz: #{minz}, maxz: #{maxz}"
surface_area = 0
fill = -1
start_point = [maxx, maxy, maxz]
puts "Starting at #{start_point}"
queue = [start_point]
void = cube.dup
void[start_point] = fill
while !queue.empty?
  point = queue.shift
  # puts "Checking #{point}" # if point.all? { |x| x % 5 == 0 }

  @side_offsets.each do |dx,dy,dz|
    neighbor = [point[0] + dx, point[1] + dy, point[2] + dz]
    next if neighbor[0] < minx || neighbor[0] > maxx || neighbor[1] < miny || neighbor[1] > maxy || neighbor[2] < minz || neighbor[2] > maxz

    if void[neighbor].nil?
      void[neighbor] = fill
      queue << neighbor
    elsif void[neighbor] >= 0
      surface_area += 1
      print "."
    end
  end
end

pp surface_area
