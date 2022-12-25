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
  visited.each do |side, x, y, direction|
    next if side.length > 1

    ox, oy = side_offset(side)
    grid[oy+y][ox+x] = direction
  end

  grid.each do |line|
    puts line.join
  end
end

instructions = path[0].scan(/\d+|\D+/)
if true
  @grid_size = 50 - 1
  @dice = {
    '1' => [(50..99), (0..49)],
    '2' => [(100..149), (0..49)],
    '3' => [(50..99), (50..99)],
    '4' => [(50..99), (100..149)],
    '5' => [(0..49), (100..149)],
    '6' => [(0..49), (150..199)]
  }
  @side_warps = {
    '1U' => '6L', '1R' => '2L', '1D' => '3U', '1L' => '5L',
    '2U' => '6D', '2R' => '4R', '2D' => '3R', '2L' => '1R',
    '3U' => '1D', '3R' => '2D', '3D' => '4U', '3L' => '5U',
    '4U' => '3D', '4R' => '2R', '4D' => '6R', '4L' => '5R',
    '5U' => '3L', '5R' => '4L', '5D' => '6U', '5L' => '1L',
    '6U' => '5D', '6R' => '4D', '6D' => '2U', '6L' => '1U'
  }
else
  @grid_size = 4 - 1
  @dice = {
    '1' => [(8..11), (0..3)],
    '2' => [(0..3), (4..7)],
    '3' => [(4..7), (4..7)],
    '4' => [(8..11), (4..7)],
    '5' => [(8..11), (8..11)],
    '6' => [(12..15), (8..11)]
  }
  @side_warps = {
    '1U' => '2U', '1R' => '6R', '1D' => '4U', '1L' => '3U',
    '2U' => '1U', '2R' => '3L', '2D' => '5D', '2L' => '6D',
    '3U' => '1L', '3R' => '4L', '3D' => '5L', '3L' => '2R',
    '4U' => '1D', '4R' => '6U', '4D' => '5U', '4L' => '3R',
    '5U' => '4D', '5R' => '6L', '5D' => '2D', '5L' => '3D',
    '6U' => '4R', '6R' => '1R', '6D' => '2L', '6L' => '5R'
  }
end

@side_offset = {}
def side_offset(side)
  @side_offset[side] ||= @dice[side].map do |range|
    range.first
  end
end

@transposes = {
  'RL' => proc { |x, y| [0, y, 'R'] },
  'LR' => proc { |x, y| [@grid_size, y, 'L'] },

  'RR' => proc { |x, y| [@grid_size, @grid_size - y, 'L'] },
  'LL' => proc { |x, y| [0, @grid_size - y, 'R'] },

  'RD' => proc { |x, y| [y, @grid_size, 'U'] },
  'DR' => proc { |x, y| [@grid_size, x, 'L'] },

  'UR' => proc { |x, y| [@grid_size, @grid_size - x, 'L'] },
  'RU' => proc { |x, y| [@grid_size - y, 0, 'D'] },

  'UL' => proc { |x, y| [0, x, 'R'] },
  'LU' => proc { |x, y| [y, 0, 'D'] },

  'LD' => proc { |x, y| [@grid_size, @grid_size - x, 'U'] },
  'DL' => proc { |x, y| [0, @grid_size - x, 'R'] },

  'DU' => proc { |x, y| [x, 0, 'D'] },
  'UD' => proc { |x, y| [x, @grid_size, 'U'] },

  'DD' => proc { |x, y| [@grid_size - x, @grid_size, 'U'] },
  'UU' => proc { |x, y| [@grid_size - x, 0, 'D'] },
}

@sides = @dice.transform_values do |coords|
  x_range, y_range = coords
  y_range.map do |y|
    x_range.map do |x|
      map[y][x]
    end
  end
end

# pp @sides['1'][0]
# raise "--"

@visited = []

current = [[0,0], 'R', '1']
while current
  x, y = current[0]
  direction = current[1]
  side = current[2]
  current_side = @sides[side]

  instruction = instructions.shift
  break if instruction.nil?

  if instruction == 'R'
    @visited << "TURNING RIGHT"
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
    @visited <<  "TURNING LEFT"
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
      current_point = [x, y]
      case direction
      when 'R'
        x += 1
      when 'D'
        y += 1
      when 'L'
        x -= 1
      when 'U'
        y -= 1
      end

      if current_side.dig(y, x).nil? || x < 0 || y < 0
        log = "WARPING from #{side} #{current_point} "
        side, new_side_direction = @side_warps["#{side}#{direction}"].chars
        log += "TO #{direction}#{new_side_direction} - "
        # puts "WARPING TO #{direction}#{new_side_direction}"
        x, y, direction = @transposes["#{direction}#{new_side_direction}"].call(*current_point)
        current_side = @sides[side]
        log += "landed at #{side} [#{x}, #{y}], going #{direction}"
        @visited << log
      end

      if current_side[y][x] == '#'
        @visited << "FOUND WALL at #{x}, #{y}, resetting to #{current_point}"
        x, y = current_point
        # side = current[2]
        # current_side = @sides[side]
        next
      end

      raise "WAT?!" if x < 0 || y < 0 || x > @grid_size || y > @grid_size

      @visited << [side, x, y, direction]
    end
  end

  current = [[x, y], direction, side]
end

pp current

puts "--------"
last_visit = @visited.filter { |v| v.is_a?(Array) }.last
pp last_visit

# render_grid(map, [143, 64])
render_grid(map, @visited)

dir_score = { "R" => 0, "D" => 1, "L" => 2, "U" => 3 }

fp_x, fp_y = last_visit[1..2]
answer_side = last_visit[0]
puts "Answer side: #{answer_side}: #{last_visit}"
ox, oy = side_offset(answer_side)
puts "Offset: #{ox}, #{oy}"
col = (fp_x + ox + 1) * 4
row = (fp_y + oy + 1) * 1000
dir = dir_score[last_visit[3]]

pp "col: #{fp_x + ox + 1}, row: #{fp_y + oy + 1}, dir: #{dir}"

pp "Final score: #{col + row + dir}"

