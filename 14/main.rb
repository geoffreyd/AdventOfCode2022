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

@max_y = @grid.keys.map { |_, y| y }.max
@off_the_edge = false

def fall(x,y)
  if y > @max_y
    @off_the_edge = true
    return
  end
  new_y = y + 1
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
    @grid[[x, y]] = 'o'
  end
end

sand = 0
until @off_the_edge
  starts = [500,0]
  sand += 1
  fall(*starts)

  puts "After #{sand} sand:"
  print_grid(@grid)

  break if sand > 1000
end

puts @grid

puts "answer: #{sand - 1}"
