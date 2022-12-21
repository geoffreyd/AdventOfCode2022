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
  return 'x' if name == 'humn'
  return job if job.is_a?(Integer)

  parts = job.split(' ')
  left = parts[0]
  op = parts[1]
  op = '=' if name == 'root'
  right = parts[2]

  left_eq = answer(left)
  left_eq = eval(left_eq) if left_eq.is_a?(String) && !left_eq.include?('x')

  right_eq = answer(right)
  right_eq = eval(right_eq) if right_eq.is_a?(String) && !right_eq.include?('x')

  case [left, op, right]
  in [_, '+', _]
    "(#{left_eq}+#{right_eq})"
  in [_, '*', _]
    "(#{left_eq}*#{right_eq})"
  in [_, '-', _]
    "(#{left_eq}-#{right_eq})"
  in [_, '/', _]
    "(#{left_eq}/#{right_eq})"
  in [_, '=', _]
    "(#{left_eq} = #{right_eq})"
  else
    raise "Unknown job: #{job}"
  end
end

pp answer('root')
