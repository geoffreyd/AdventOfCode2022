# frozen_string_literal: true
require 'json'
require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

def compare(pair, depth = 0)
  left, right = pair
  puts "#{' ' * depth}- Compare #{left} and #{right}"
  case pair
  in [[], []]
    0
  in [Array, nil]
    puts "#{' ' * depth}- right nil"
    +1
  in [Integer, nil]
    puts "#{' ' * depth}- right nil"
    +1
  in [nil, Array]
    puts "#{' ' * depth}- left nil"
    -1
  in [nil, Integer]
    puts "#{' ' * depth}- left nil"
    -1
  in [Integer, Integer]
    left <=> right
  in [Array, Array]
    ret = nil
    size = [left.size, right.size].max
    size.times do |i|
      ret = compare([left[i], right[i]], depth + 1)
      if ret != 0
        break
      end
    end
    ret
  in [Integer, Array]
    puts "#{' ' * depth}- Mixed Types, convert, and try"
    compare([[left], right])
  in [Array, Integer]
    puts "#{' ' * depth}- Mixed Types, convert, and try"
    compare([left, [right]])
  else
    puts "WAT?!"
  end
end

messages = lines.slice_after('').map.with_index do |group, idx|
  pair = group.reject{_1 == ""}.map { |line|
    list = JSON.parse(line)
  }
  puts "== Pair #{idx + 1} =="
  result = compare(pair)
  puts "=> #{result}"

  [idx + 1, result.nil? ? nil : result < 0]
end

puts messages.filter { _1[1] == true}.map { _1[0] }.sum
