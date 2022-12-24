# frozen_string_literal: true

path = './input.txt'
lines = IO.readlines(path, chomp: true)

grid = {}
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    grid[[x + 1000, y + 1000]] = char if char == '#'
  end
end

def direction_empty?(grid, point, points)
  points.none? { |x, y| grid[[point[0] + x, point[1] + y]] == '#' }
end

def print_grid(grid)
  min_x, max_x = grid.keys.map(&:first).minmax
  min_y, max_y = grid.keys.map(&:last).minmax
  land = 0

  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      if grid[[x, y]]
        print grid[[x, y]]
      else
        land += 1
        print '.'
      end
    end
    puts
  end
  puts "Land: #{land}"
end

@around = [-1, 0, 1].repeated_permutation(2).reject { _1.zero? && _2.zero? }

@directions = [
  # North, north east, north west
  [[0, -1], [1, -1], [-1, -1]],
  # South, south east, south west
  [[0, 1], [1, 1], [-1, 1]],
  # West, north west, south west
  [[-1, 0], [-1, -1], [-1, 1]],
  # East, north east, south east
  [[1, 0], [1, -1], [1, 1]]
]

i = 0
loop do
  i += 1
  proposals = {}

  elves = grid.keys

  # Collect Proposals
  elves.each do |curr_point|
    # pp "Evaluating #{curr_point}"
    if direction_empty?(grid, curr_point, @around)
      # proposals[curr_point] ||= []
      # proposals[curr_point] << curr_point
      # pp "Empty around #{curr_point}, staying put"
      next
    end
    # Check each direction
    @directions.each do |direction|
      next unless direction_empty?(grid, curr_point, direction)

      offset = direction.first
      target = [curr_point[0] + offset[0], curr_point[1] + offset[1]]
      proposals[target] ||= []
      proposals[target] << curr_point
      # pp "Empty in #{direction.first}, moving there"
      break
    end
  end

  # pp proposals
  # Validate proposals
  if proposals.empty?
    puts "No proposals after #{i} rounds"
    break
  end

  proposals.each do |target, origins|
    next if origins.size > 1

    grid[target] = '#'
    grid.delete(origins.first)
  end

  @directions.rotate!

  # puts "----- After #{i} rounds -----"
  # break if i > 30
end
print_grid(grid)
