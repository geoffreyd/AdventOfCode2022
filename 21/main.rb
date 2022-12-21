# frozen_string_literal: true

path = './input.txt'
lines = IO.readlines(path, chomp: true)

@monkeys = lines.map do |line|
  name, job = line.split(': ')
  job = job.to_i if job =~ /\A\d+\z/
  [name, job]
end.to_h

def answer(name)
  job = @monkeys[name]
  return job if job.is_a?(Integer)

  parts = job.split(' ')
  left = parts[0].to_i
  op = parts[1]
  right = parts[2].to_i
  case [left, op, right]
  in [Integer, '+', Integer]
    answer(parts[0]) + answer(parts[2])
  in [Integer, '*', Integer]
    answer(parts[0]) * answer(parts[2])
  in [Integer, '-', Integer]
    answer(parts[0]) - answer(parts[2])
  in [Integer, '/', Integer]
    answer(parts[0]) / answer(parts[2])
  else
    raise "Unknown job: #{job}"
  end
end

pp answer('root')
