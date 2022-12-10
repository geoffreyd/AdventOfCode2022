# frozen_string_literal: true

require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

@v = 1
@cycles = 0
@current_instruction = []
@inspected = []

inspect = [20, 60, 100, 140, 180, 220]
# inspect = [1,2,3,4,5,6,7]

def inspect_register(cycle)
  puts "V: #{@v} on cycle #{cycle} for #{@v * cycle}"
  @inspected << (@v * cycle)
end

(1..220).each do |i|
  inspect_register(i) if inspect.include?(i)
  if @current_instruction[0] == :addx
    @v += Regexp.last_match(1).to_i
    @current_instruction = []
  else
    line = lines.shift
    case line
    when /noop/
      # nothing
    when /addx (-?\d+)/
      @current_instruction = [:addx, Regexp.last_match(1).to_i]
      # puts "next instruction: addx #{$1}"
    end
  end
end

pp 'Part 1'
pp @inspected.sum

### Part 2

lines = IO.readlines(path, chomp: true)
@crt = (0..5).map { Array.new(40) }

def render_crt
  @crt.each do |row|
    puts row.map { |c| c == 1 ? '#' : ' ' }.join
  end
end

@x = 1
@current_instruction = []

(1..1000).each do |i|
  current_row = (i - 1) / 40
  current_col = (i - 1) % 40

  break if current_row > 5

  # puts "Cycle #{i} - x: #{@x} - current row: #{current_row} - current col: #{current_col}"
  @crt[current_row][current_col] = 1 if [@x - 1, @x, @x + 1].include? current_col

  if @current_instruction[0] == :addx
    @x += @current_instruction[1]
    @current_instruction = []
  else
    line = lines.shift
    break if line.nil?

    case line
    when /noop/
      # nothing
    when /addx (-?\d+)/
      @current_instruction = [:addx, Regexp.last_match(1).to_i]
      # puts "next instruction: addx #{$1}"
    end
  end

  # render_crt
  # puts "end of cycle #{i} - x: #{@x} - current row: #{current_row} - current col: #{current_col}"
end

puts ''
puts 'Part 2'
render_crt
