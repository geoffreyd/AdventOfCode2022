# frozen_string_literal: true

require 'debug'

path = './input.txt'

input = IO.readlines(path, chomp: true)

line = input.first

part2 = false

offset = part2 ? 14 : 4

line.chars.each_cons(offset) do |bytes|
  if bytes.uniq.size == offset
    pp bytes
    pp line.index(bytes.join) + offset
    raise
  end
end
