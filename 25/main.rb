# frozen_string_literal: true

path = './input.txt'
lines = IO.readlines(path, chomp: true)

@mapping = { '2' => 2, '1' => 1, '0' => 0, '-' => -1, '=' => -2 }

def from_snafu_number(str)
  values = str.chars.map do |c|
    @mapping[c]
  end

  values.reverse.each_with_index.map do |value, index|
    value * 5**index
  end.sum
end

sum = lines.map do |line|
  from_snafu_number(line)
end.sum

pp sum

val = []
while sum.positive?
  m = sum % 5
  val << '012=-'[m]
  sum /= 5
  sum += 1 if m >= 3
end

pp val.reverse.join
