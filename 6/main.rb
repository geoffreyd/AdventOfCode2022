# frozen_string_literal: true

path = './input.txt'
line = IO.readlines(path, chomp: true).first

part2 = false
offset = part2 ? 14 : 4

marker = line.chars.each_cons(offset).find do |bytes|
  bytes.uniq.size == offset
end

pp line.index(marker.join) + offset
