# frozen_string_literal: true
require 'debug'

path = './5/input.txt'

input = IO.readlines(path, chomp: true)

drawing, instructions = input.slice_after('').to_a

stacks_nos = drawing[-2].chars

crates = drawing[0...-2].map(&:chars)

stacks = {}

stacks_nos.each do |no|
  next if no == ' '

  idx = stacks_nos.index(no)
  stacks[no] = crates.map { _1[idx] }.reverse.reject { _1 == ' ' }
end

numbers = instructions.map do |line|
  _, count, dest, target = *line.match(/move (\d{1,2}) from (\d) to (\d)/)

  [count.to_i, dest, target]
end

part2 = true

numbers.each do |c, d, t|
  to_move = stacks[d].pop(c)
  to_move = to_move.reverse unless part2
  stacks[t].push(*to_move)
end
pp stacks.map { |_k, v| v.last }.join
