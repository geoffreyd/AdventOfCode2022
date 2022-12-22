# frozen_string_literal: true

path = './input.txt'
lines = IO.readlines(path, chomp: true)

input = lines.slice_after('')

map, path = input.to_a

map = map.map { |line| line.chars }

start_x = map[0].index('.')

start = [start_x, 0]

def render_grid(grid, visited)
  grid = grid.dup
  visited.each do |x, y|
    grid[y][x] = 'O'
  end

  grid.each do |line|
    puts line.join
  end
end

current = [start, 'R']
instructions = path[0].scan(/\d+|\D+/)
@visited = []

while current
  x, y = current[0]
  direction = current[1]

  instruction = instructions.shift
  break if instruction.nil?

  if instruction == 'R'
    direction = case direction
                when 'R'
                  'D'
                when 'D'
                  'L'
                when 'L'
                  'U'
                when 'U'
                  'R'
                end
  elsif instruction == 'L'
    direction = case direction
                when 'R'
                  'U'
                when 'D'
                  'R'
                when 'L'
                  'D'
                when 'U'
                  'L'
                end
  else
    instruction.to_i.times do
      break if x.nil? || y.nil?
      current = [x, y]
      case direction
      when 'R'
        x += 1
        if [' ', nil].include?(map.dig(y, x))
          x = map[y].index { |c| c == '#' || c == '.' }
        end
      when 'D'
        y += 1
        if [' ', nil].include?(map.dig(y, x))
          y = map.index { |line| line[x] == '#' || line[x] == '.' }
        end
      when 'L'
        x -= 1
        if [' ', nil].include?(map.dig(y, x))
          x = map[y].rindex { |c| c == '#' || c == '.' }
        end
      when 'U'
        y -= 1
        if [' ', nil].include?(map.dig(y, x))
          y = map.rindex { |line| line[x] == '#' || line[x] == '.' }
        end
      end

      break if x.nil? || y.nil?
      if map[y][x] == '#'
        x, y = current
        next
      end
      @visited << [x,y]
    end
  end

  current = [[x, y], direction]
end

pp current

pp @visited

render_grid(map, [])
render_grid(map, @visited)

dir_score = { "R" => 0, "D" => 1, "L" => 2, "U" => 3 }

final_point = current[0]
col = (final_point[0] + 1) * 4
row = (final_point[1] + 1) * 1000
dir = dir_score[current[1]]

pp "Final score: #{col + row + dir}"

