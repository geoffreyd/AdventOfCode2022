# frozen_string_literal: true

require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

movements = {
  'U' => [0, 1],
  'D' => [0, -1],
  'L' => [-1, 0],
  'R' => [1, 0]
}
FOLLOW = {
  [0, 0] => [0, 0],
  [0, -1] => [0, 0],
  [0, 1] => [0, 0],
  [-1, 1] => [0, 0],
  [-1, -1] => [0, 0],
  [-1, 0] => [0, 0],
  [1, -1] => [0, 0],
  [1, 0] => [0, 0],
  [1, 1] => [0, 0],

  [0, 2] => [0, 1],
  [0, -2] => [0, -1],
  [-2, 0] => [-1, 0],
  [2, 0] => [1, 0],

  [-2, -1] => [-1, -1],
  [2, -1] => [1, -1],
  [2, 1] => [1, 1],
  [-2, 1] => [-1, 1],
  [-1, -2] => [-1, -1],
  [-1, 2] => [-1, 1],
  [1, -2] => [1, -1],
  [1, 2] => [1, 1],

  [2, 2] => [1, 1],
  [-2, -2] => [-1, -1],
  [-2, 2] => [-1, 1],
  [2, -2] => [1, -1]

}

tail_visits = ['0,0']
current_h_pos = [0, 0]
current_t_pos = [0, 0]
RENDER_CHARS = %w[H 1 2 3 4 5 6 7 8 T]

def render_grid(size = 5, point_lists)
  puts '     --    '
  grid = (0..size).map do |y|
    (0..size).map do |x|
      point_lists.each_with_index.map do |points, i|
        points.include?([x, y]) ? RENDER_CHARS[i] : nil
      end.compact.first || '.'
    end
  end

  grid.reverse.each { |row| puts row.join }
end

def follow(head, tail)
  # find difference between head and tail
  diff = head.zip(tail).map { |a, b| a - b }
  to_move = FOLLOW[diff]
  if to_move.nil?
    pp "Missing move for #{diff}, lead: #{head}, tail: #{tail}"
    tail
  else
    tail.zip(to_move).map(&:sum)
  end
end

lines.each do |line|
  direction, distance = line.split(' ')
  distance = distance.to_i

  distance.times do
    current_h_pos = current_h_pos.zip(movements[direction]).map(&:sum)
    current_t_pos = follow(current_h_pos, current_t_pos)
    tail_visits << current_t_pos.join(',')
  end

  # render_grid(5, tail_visits.map { |visit| visit.split(',').map(&:to_i) })
end

# pp tail_points
pp tail_visits.uniq.size

### Part 2

tail_visits = ['0,0']
head_visits = ['0,0']
current_knots = (0..9).map { [0, 0] }

lines.each do |line|
  direction, distance = line.split(' ')
  distance = distance.to_i

  distance.times do
    current_knots[0] = current_knots[0].zip(movements[direction]).map(&:sum)

    (1..9).each do |i|
      current_knots[i] = follow(current_knots[i - 1], current_knots[i])
    end

    # render_grid(20, current_knots.map { [_1] })

    tail_visits << current_knots[-1].join(',')
    head_visits << current_knots[0].join(',')
  end
end

puts 'Part 2: '
pp tail_visits.uniq.size
