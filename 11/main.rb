# frozen_string_literal: true

require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

class Monkey
  attr_accessor :items
  attr_reader :id, :inspection_count

  def initialize(id, items, operation, test, if_true, if_false)
    @id = id
    @items = items
    @operation = operation
    @div_by = test
    @if_true = if_true
    @if_false = if_false
    @inspection_count = 0
  end

  def tick(all_monkeys)
    # puts "Monkey #{@id}"
    while @items.any?
      item = @items.shift
      value = operation(item)
      @inspection_count += 1
      value /= 3 # relief
      throw_to(all_monkeys, test(value) ? @if_true : @if_false, value)
    end
  end

  def operation(item)
    old = item
    eval(@operation)
  end

  def test(value)
    (value % @div_by).zero?
  end

  def throw_to(all_monkeys, monkey, value)
    all_monkeys[monkey].items << value
  end

  def print_items
    puts "Monkey #{@id}: #{@items.join(", ")}"
  end
end

@monkeys = lines.slice_after("").map do |monkey_desc|
  # extract info from data that looks like
  # Monkey 0:
  # Starting items: 79, 98
  # Operation: new = old * 19
  # Test: divisible by 23
  #   If true: throw to monkey 2
  #   If false: throw to monkey 3

  Monkey.new(
    monkey_desc[0].split(" ")[1].to_i,
    monkey_desc[1].split(":")[1].split(",").map(&:to_i),
    monkey_desc[2].split("new = ")[1].strip,
    monkey_desc[3].split("divisible by ")[1].to_i,
    monkey_desc[4].split("throw to monkey ")[1].to_i,
    monkey_desc[5].split("throw to monkey ")[1].to_i
  )

end

20.times.each do |i|
  @monkeys.each do |monkey|
    monkey.tick(@monkeys)
  end

  # @monkeys.each { _1.print_items }
end

pp @monkeys.map { _1.inspection_count }.sort.last(2).inject(&:*)

