# frozen_string_literal: true

require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)


movements = {
  "U" => [0, 1],
  "D" => [0, -1],
  "L" => [-1, 0],
  "R" => [1, 0]
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
  [1, 2] => [1, 1]

}

tail_visits = ["0,0"]
current_h_pos = [0, 0]
current_t_pos = [0, 0]

def follow(head, tail)
  # find difference between head and tail
  diff = head.zip(tail).map { |a, b| a - b }
  to_move = FOLLOW[diff]
  if to_move.nil?
    pp "Missing move for #{diff}"
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
end

tail_points = tail_visits.map! { |visit| visit.split(',').map(&:to_i) }

# render tail_points in a 6x6 grid
grid = (0..5).map do |y|
  (0..5).map do |x|
    tail_points.include?([x, y]) ? 'X' : '.'
  end
end

grid.reverse.each { |row| pp row.join }


# pp tail_points
pp tail_visits.uniq.size

