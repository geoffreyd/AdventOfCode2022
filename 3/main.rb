# frozen_string_literal: true

path = './sample.txt'
path = './input.txt'

input = IO.readlines(path, chomp: true)

priorities = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.chars

ips = input.map do |items|
  # split string in half
  first, second = items.chars.each_slice(items.length / 2).to_a
  common = first.intersection(second).first

  priority = priorities.index(common) + 1
end.to_a

pp ips.sum

### Part 2

badges = input.each_slice(3).map do |group|
  badge = group[0].chars.intersection(group[1].chars, group[2].chars).first

  priorities.index(badge) + 1
end

pp badges.sum
