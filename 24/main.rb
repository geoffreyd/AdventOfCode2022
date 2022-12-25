# frozen_string_literal: true

require 'set'
path = './input.txt'
lines = IO.readlines(path, chomp: true)

grid = {}

lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    if char == '#'
      grid[[x, y]] = char
      next
    end
    grid[[x, y]] ||= []
    grid[[x, y]] << char if char != '.'
  end
end
@min_x, @max_x = grid.keys.map(&:first).minmax
@min_y, @max_y = grid.keys.map(&:last).minmax

@advance_storms = {}
def advance_storms(minutes, grid)
  return grid if minutes == 0
  new_grid = grid.select { |_, val| val == '#' }
  @advance_storms[minutes] ||= begin
    grid.each do |point, val|
      next if val == '#'

      val.each do |char|
        new_point = case char
                    when '<'
                      prop = [point[0] - 1, point[1]]
                      new_grid[prop] == '#' ? [@max_x - 1, point[1]] : prop
                    when '>'
                      prop = [point[0] + 1, point[1]]
                      new_grid[prop] == '#' ? [@min_x + 1, point[1]] : prop
                    when '^'
                      prop = [point[0], point[1] - 1]
                      new_grid[prop] == '#' ? [point[0], @max_y - 1] : prop
                    when 'v'
                      prop = [point[0], point[1] + 1]
                      new_grid[prop] == '#' ? [point[0], @min_y + 1] : prop
                    end
        new_grid[new_point] ||= []
        new_grid[new_point] << char
      end
    end
    pp "Storms for minute #{minutes}:"
    # print_grid(new_grid)
    new_grid
  end
end

def print_grid(grid, visited)
  min_x, max_x = grid.keys.map(&:first).minmax
  min_y, max_y = grid.keys.map(&:last).minmax

  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      if visited[[x, y]]
        print visited[[x, y]]
        next
      end
      val = grid[[x, y]]
      if val.is_a? Array
        if val.length > 1
          print val.length
        else
          print val.first || '.'
        end
      else
        print val || '.'
      end
    end
    puts
  end
end

def heuristic_cost_estimate(current, goal)
  (current[0] - goal[0]).abs + (current[1] - goal[1]).abs
end

def neighbors(grid, point)
  [
    [point[0] - 1, point[1]],
    [point[0] + 1, point[1]],
    [point[0], point[1] - 1],
    [point[0], point[1] + 1],
    point
  ].select do |neighbor|
    (grid[neighbor].nil? || grid[neighbor].empty?) && neighbor[0] >= @min_x && neighbor[0] <= @max_x && neighbor[1] >= @min_y && neighbor[1] <= @max_y
  end
end

def bfs(grid, starting_point, destination)
  queue = Set.new
  queue.add [starting_point, 0, 0]
  storms = grid
  @advance_storms[0] = grid
  visited = {}
  visited[starting_point] = 1
  cuttoff = heuristic_cost_estimate(starting_point, destination) * 4
  # parent = {}

  while queue.any?
    next_point = queue.min_by { |point| point[2] }
    current_point, distance, _ = next_point
    storms = @advance_storms[distance]
    raise "missing storm for #{distance}" unless storms
    queue.delete next_point

    # x, y = current_point
    if current_point == destination
      puts "Found destination: #{current_point}, distance: #{distance}"
      break
    end
    visited[current_point] ||= 0
    visited[current_point] += 1
    storms = advance_storms(distance+1, storms)

    next if distance > cuttoff

    # puts "Visiting: #{current_point} (#{grid[current_point]})"

    neighbors = neighbors(storms, current_point)
    puts "Neighbors - #{current_point}: #{neighbors.length} - #{neighbors}"
    neighbors.each do |point|
      queue.add [point, distance + 1, heuristic_cost_estimate(point, destination)]
      # parent[point] = current_point if point != current_point
    end
    # puts "Queue: #{queue}"
  end

  print_grid(grid, visited)

  path = []
  # current_point = destination
  # while !path.include? current_point
  #   path << current_point
  #   current_point = parent[current_point]
  #   throw "nil point" if current_point.nil?
  # end
  path.reverse
end

start = [lines[0].index('.'), 0]
dest = [lines[-1].index('.'), lines.length - 1]

puts "Start: #{start}, Dest: #{dest}"

# print_grid(grid)
paths = bfs(grid, start, dest)
# pp paths

# pp "Storm keys #{@advance_storms.keys}"

# pp "Shortest path: #{paths.min_by { |p| p[0] }}"
