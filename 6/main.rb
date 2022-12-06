# frozen_string_literal: true

path = './input.txt'
line = IO.readlines(path, chomp: true).first

part2 = false
offset = part2 ? 14 : 4

marker, idx = line.chars.each_cons(offset).with_index.find do |chars, _|
  chars.uniq.size == offset
end

pp idx + offset
