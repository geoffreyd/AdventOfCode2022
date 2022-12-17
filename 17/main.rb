# frozen_string_literal: true

require 'debug'
require 'set'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

input = lines.first.chars;

shapes = [
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

def render_grid(height, grid)
  height.downto(0).each do |y|
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
    tmp_grid[y + y_offset][x + x_offset] = '#'
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

until @rocks_fallen == 2022 do
  shape_index = @rocks_fallen % shape_count
  shape = shapes[shape_index].dup

  max_y = @grid.count
  y_offset = max_y + 3
  x_offset = 2

  while true
    # can be pushed?
    direction = input[@input_idx]
    @input_idx = (@input_idx + 1) % input.count
    shift_offset = direction == "<" ? -1 : 1

    # print "Can be pushed? #{direction}"
    if !colide?(shape, x_offset + shift_offset, y_offset)
      x_offset += shift_offset
      # puts " Yes"
    else
      # puts " No"
    end
    # render_test_grid(y_offset, shape, x_offset, y_offset, @grid)

    # can fall?
    # print "Can fall?"
    if !colide?(shape, x_offset, y_offset - 1)
      y_offset -= 1
      # puts " Yes"
    else
      # puts " No - setting shape at x: #{x_offset}, y: #{y_offset}"
      # set shape on grid
      shape.each do |x, y|
        @grid[y + y_offset] ||= []
        @grid[y + y_offset][x + x_offset] = '#'
      end

      @rocks_fallen += 1
      break
    end
    # render_test_grid(y_offset, shape, x_offset, y_offset, @grid)
  end

  # render_grid(y_offset+4, @grid)

end

puts @grid.count - 1
