# frozen_string_literal: true

require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

@elevations = ('a'..'z').to_a
@elevations << "E"

current_elevation = 0

grid = lines.map { |line| line.split('') }

def render_grid(grid)
  grid.each do |row|
    # puts row.map { |elevation| elevation.nil? ? '.' : @elevations[elevation] }.join
    puts row.join('')
  end
end

render_grid(grid)

starting_point = nil
destination = nil

grid.each_with_index do |row, y|
  row.each_with_index do |elevation, x|
    starting_point = [x, y] if elevation == 'S'
    destination = [x, y] if elevation == 'E'
  end
end

puts "Starting point: #{starting_point}, destination: #{destination}"

# find shortest path from starting point to destination
def bfs(grid, starting_point, destination)
  queue = [starting_point]
  visited = {}
  visited[starting_point] = true
  parent = {}

  while queue.any?
    current_point = queue.shift
    x, y = current_point
    if current_point == destination
      puts "Found destination: #{current_point}"
      break
    end

    puts "Visiting: #{current_point} (#{grid[y][x]})"
    current_elevation = if current_point == starting_point
      0
    else
      @elevations.index(grid[y][x])
    end

    [[x, y + 1], [x, y - 1], [x + 1, y], [x - 1, y]].each do |point|
      next if point[0] < 0 || point[0] >= grid[0].size
      next if point[1] < 0 || point[1] >= grid.size
      next if visited[point]
      next if grid[point[1]][point[0]].nil?
      puts "Checking: #{point} at elevation: #{grid[point[1]][point[0]]}"

      point_elevation = @elevations.index(grid[point[1]][point[0]])
      puts "Point elevation: #{point_elevation}, current elevation: #{current_elevation}"
      diff = point_elevation - current_elevation
      next unless diff <= 1

      queue << point
      visited[point] = true
      parent[point] = current_point
    end
    puts "Queue: #{queue}"
  end

  path = []
  current_point = destination
  # while current_point != starting_point
  while @elevations.index(grid[current_point[1]][current_point[0]]) != 0
    path << current_point
    current_point = parent[current_point]
    throw "nil point" if current_point.nil?
  end
  path << current_point
  path.reverse
end

path = bfs(grid, starting_point, destination)
puts "Path: #{path}"
puts "Elevations: #{path.map { |point| grid[point[1]][point[0]] }}"
puts "Path length: #{path.size - 1}"
