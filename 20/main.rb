# frozen_string_literal: true

path = './input.txt'
@numbers = IO.readlines(path, chomp: true).map(&:to_i)

def decode(key, n)
  numbers = @numbers.map { _1 * key }
  indices = (0...numbers.length).to_a

  (indices * n).each do |i|
    j = indices.index(i)
    indices.delete_at(j)
    indices.insert((j + numbers[i]) % indices.length, i)
  end

  zero = indices.index(numbers.index(0))
  [1, 2, 3].sum { |p|
    numbers[indices[(zero + p * 1000) % numbers.length]].tap { |n| puts "n: #{n}" }
  }
end

puts decode(1, 1)
puts decode(811_589_153, 10)
