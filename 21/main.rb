# frozen_string_literal: true

path = './input.txt'
lines = IO.readlines(path, chomp: true)

@monkeys = lines.map do |line|
  name, job = line.split(': ')
  job = job.to_i if job =~ /\A\d+\z/
  [name, job]
end.to_h

@inverts = { '+' => '-', '-' => '+', '*' => '/', '/' => '*' }

def simplify(args)
  case args
  in [Integer => left, op, Integer => right] if @inverts.keys.include?(op)
    left.send(op, right)
  else
    args
  end
end

def resolve(value, commands)
  print "value: #{value} "
  return value if commands == 'x'

  left, op, right = commands
  next_commands, x = left.is_a?(Numeric) ? [right, left] : [left, right]

  puts " #{@inverts[op]} #{x}"
  resolve(value.send(@inverts[op], x), next_commands)
end

def answer(name, part2)
  job = @monkeys[name]
  return 'x' if name == 'humn' && part2
  return job if job.is_a?(Integer)

  parts = job.split(' ')
  left = parts[0]
  op = name == 'root' && part2 ? '=' : parts[1]
  right = parts[2]

  [simplify(answer(left, part2)), op, simplify(answer(right, part2))]
end

p1_l, p1_op, p1_r = answer('root', false)
puts "Part 1: #{p1_l} #{p1_op} #{p1_r} = #{p1_l.send(p1_op, p1_r)}"

commands, _, value = answer('root', true)
# pp commands

pp resolve(value, commands)
