# frozen_string_literal: true

require 'debug'
require 'set'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

@input = input = lines.first.chars;

@shapes = shapes = [
  [[0, 0], [1, 0], [2, 0], [3, 0]], # -
  [[1, 0], [0, 1], [1, 1], [2, 1], [1, 2]], # +
  [[0, 0], [1, 0], [2, 0], [2, 1], [2, 2]], # _|
  [[0, 0], [0, 1], [0, 2], [0, 3]], # |
  [[0, 0], [0, 1], [1, 0], [1, 1]] # o
]
shape_count = shapes.count

@rocks_fallen = 0
@input_idx = 0
@grid = [[]]

@grid[0][0] = '-'
@grid[0][1] = '-'
@grid[0][2] = '-'
@grid[0][3] = '-'
@grid[0][4] = '-'
@grid[0][5] = '-'
@grid[0][6] = '-'

def render_grid(height, grid, down = 0)
  height.downto(down).each do |y|
    7.times.each do |x|
      print (grid[y] || [])[x] || '.'
    end
    puts
  end
  puts
end

def render_test_grid(height, shape, x_offset, y_offset, grid)
  tmp_grid = grid.dup
  shape.each do |x, y|
    tmp_grid[y + y_offset] ||= []
    tmp_grid[y + y_offset][x + x_offset] = '@'
  end

  render_grid(height, tmp_grid)
end

def colide?(shape, x_offset, y_offset)
  shape.any? do |x, y|
    new_x = x + x_offset
    return true if new_x < 0 || new_x > 6

    row = @grid[y + y_offset] || []
    row[new_x]
  end
end

@cleared_below = 0

@pattern_finder = {}
@target_rocks = 1_000_000_000_000

@has_jumped = false

@fall_cache = {}
def fall_rock(shape_idx, input_idx, grid)
  grid_hash = grid.hash

  # puts "grid: #{grid.flatten}"
  # puts "grid_hash: #{grid_hash}"


  shape = @shapes[shape_idx].dup

  max_y = @grid.count
  y_offset = max_y + 3
  x_offset = 2

  while true
    # can be pushed?
    direction = @input[input_idx]
    input_idx = (input_idx + 1) % @input.count
    shift_offset = direction == '<' ? -1 : 1

    # print "Can be pushed? #{direction}"
    unless colide?(shape, x_offset + shift_offset, y_offset)
      x_offset += shift_offset
    end
    # render_test_grid(y_offset, shape, x_offset, y_offset, @grid)

    # can fall?
    # print "Can fall?"
    if !colide?(shape, x_offset, y_offset - 1)
      y_offset -= 1
      # current_falls += 1
      # puts " Yes"
      if y_offset < 0
        break
        # render_test_grid(grid.count, shape, x_offset, y_offset, @grid)
        # raise "LOOP!"
      end
    else
      # set shape on grid
      shape.each do |x, y|
        @grid[y + y_offset] ||= []
        @grid[y + y_offset][x + x_offset] = '#'
      end

      @rocks_fallen += 1
      # @max_fall = current_falls if current_falls > @max_fall
      break
    end
    # render_test_grid(y_offset, shape, x_offset, y_offset, @grid)
  end
  if @grid.count > 1000 && !@has_jumped
    grid_head_hash = @grid[-35..-1]
    if @pattern_finder[grid_head_hash]

      prev_rocks, prev_height = @pattern_finder[grid_head_hash]
      pattern_height = @total_height - prev_height
      pattern_rocks = @rocks_fallen - prev_rocks

      puts "Pattern found at: #{@rocks_fallen}"
      puts "height started at: #{prev_height}, with #{prev_rocks} rocks"
      puts "height now at: #{@total_height}, with #{@rocks_fallen} rocks"
      puts "The difference is: #{pattern_height}, with #{pattern_rocks} rocks"

      rocks_to_go = @target_rocks - @rocks_fallen
      loop_count = rocks_to_go / pattern_rocks
      height_to_add = loop_count * pattern_height
      rocks_to_add = loop_count * pattern_rocks

      puts "going to add #{rocks_to_add} rocks and #{height_to_add} height"
      puts "to make a total of #{@rocks_fallen + rocks_to_add} rocks and #{@total_height + height_to_add} height"

      @total_height += height_to_add
      @rocks_fallen += rocks_to_add

      @has_jumped = true
      # pp @pattern_finder[grid_head.hash]
      # puts "--"
      # pp [@rocks_fallen, @total_height]
      # raise "found pattern"
    else
      @pattern_finder[grid_head_hash] = [@rocks_fallen, @total_height]
    end
  end
  [
    @grid.count - max_y,
    @grid,
    input_idx
  ]
end

@max_fall = 0
# pattern_repeat = 2695
# pattern_repeat = 53
@total_height = 0

until @rocks_fallen >= @target_rocks
  # clean_grid if @rocks_fallen % 100 == 0

  shape_index = @rocks_fallen % shape_count

  height_gained, new_grid, in_idx = fall_rock(shape_index, @input_idx, @grid)
  @total_height += height_gained
  @grid = new_grid
  @input_idx = in_idx
  # puts "Height gained: #{height_gained}, total height: #{@total_height}"

  # render_grid(@grid.count, @grid) if @rocks_fallen > 30
  # print '.' if @rocks_fallen % 50000 == 0
end

puts 'Done'
# render_grid(@grid.count + 2, @grid)

puts @total_height
