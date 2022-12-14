# frozen_string_literal: true
require 'json'
require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

rocks = lines.map do |line|
  points = line.split(' -> ').map do |point|
    x, y = point.split(',').map(&:to_i)
    [x, y]
  end
end

rocks.each do |rock|
  puts rock.inspect
end

def print_grid(grid)
  # find the max x and y
  min_x, max_x = grid.keys.map { |x, _| x }.minmax
  min_y, max_y = grid.keys.map { |_, y| y }.minmax

  puts "Drawing grid from #{min_x}, #{min_y} to #{max_x}, #{max_y}"

  (min_y - 1..max_y + 1).each do |y|
    puts (min_x-1..max_x+1).map { |x|
      grid[[x, y]] || '.'
    }.join('')
  end
end

@grid = {
  [500,0] => '+'
}

rocks.each do |rock_points|
  rock_points.each_cons(2).each do |point1, point2|
    # fill in between the points
    x1, y1 = point1
    x2, y2 = point2

    if x1 == x2
      # vertical
      Range.new(*[y1,y2].sort).each do |y|
        @grid[[x1, y]] = '#'
      end
    else
      # horizontal
      Range.new(*[x1,x2].sort).each do |x|
        @grid[[x, y1]] = '#'
      end
    end
  end
end

print_grid(@grid)

@max_y = @grid.keys.map { |_, y| y }.max + 2
@min_rock_x, @max_rock_x = @grid.keys.map { |x, _| x }.minmax
@is_full = false

def fall(x,y)
  # distance_from_center = (x + 1 - 500).abs
  if (x > @max_rock_x + 2 || x < @min_rock_x - 2)
    @grid[[x, y]] = '|'
    return;
  end

  new_y = y + 1
  if new_y == @max_y
    @grid[[x, @max_y]] ||= '#'
    @grid[[x-1, @max_y]] ||= '#'
    @grid[[x+1, @max_y]] ||= '#'
  end
  if @grid[[x, new_y]].nil?
    return fall(x, new_y)
  end

  # if we can't fall, we need to check if we can spread
  if @grid[[x-1, new_y]].nil?
    fall(x-1, new_y)
  elsif @grid[[x+1, new_y]].nil?
    fall(x+1, new_y)
  else
    # we can't fall, and we can't spread
    if [x, y] == [500, 0]
      @is_full = true
      return
    end
    @grid[[x, y]] = 'o'
  end
end

sand = 0
until @is_full
  starts = [500,0]
  sand += 1
  fall(*starts)

  puts "After #{sand} sand:"
  print_grid(@grid)

  # break if sand > 1000
end

# puts @grid

puts "answer: #{sand}"

# find man max y for '|' greater than x 500
right = @grid.keys.select { |x, y| @grid[[x, y]] == '|' && x > 500 }.map { |_, y| y }.minmax
right_sand = (right[1] - right[0]).times.map { _1 + 1}.sum
left = @grid.keys.select { |x, y| @grid[[x, y]] == '|' && x < 500 }.map { |_, y| y }.minmax
left_sand = (left[1] - left[0]).times.map { _1 + 1}.sum

puts "sand: #{sand} + #{right_sand} + #{left_sand}"
puts "answer: #{sand + right_sand + left_sand}"
