# path = './sample.txt'
path = './input.txt'

input = IO.readlines(path, chomp: true)

overlaps = input.filter do |input_line|
  pair1, pair2 = input_line.split(',')
  range1 = Range.new(*pair1.split('-').map(&:to_i))
  range2 = Range.new(*pair2.split('-').map(&:to_i))

  overlap = range1.to_a.intersection range2.to_a

  pp overlap
  overlap == range1.to_a || overlap == range2.to_a
end

pp overlaps.size
