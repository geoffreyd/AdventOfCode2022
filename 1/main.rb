# frozen_string_literal: true

input = IO.readlines('./input.txt', chomp: true)

elf_values = input.slice_after('').map { _1.map(&:to_i).sum }

pp elf_values.max # part 1
pp elf_values.max(3).sum # part 2
