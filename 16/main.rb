# frozen_string_literal: true

require 'debug'
require 'set'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

@valves = {}
@paths = {}
@state = {}

lines.each do |line|
  id, flow, paths = line.match(/Valve ([A-Z]{2}) has flow rate=(\d{1,2}); tunnels? leads? to valves? (.*)/).captures

  @valves[id] = flow.to_i
  @paths[id] = paths.split(', ')
  @state[id] = {
    rate: flow.to_i,
    valves: @paths[id]
  }
end

@valve_count = @valves.count
@cache = {}

@part2 = false

def maxflow(cur, opened, min_left)
  @cache[[cur, opened, min_left]] ||= begin
    if min_left <= 0
      return 0
    end

    best = 0
    state = @state[cur]
    state[:valves].each do |valve|
      best = [best, maxflow(valve, opened, min_left - 1)].max
    end

    if !opened.include?(cur) && state[:rate] > 0 && min_left >= 0
      opened = opened.dup
      opened.add(cur)
      min_left -= 1
      new_sum = min_left * state[:rate]

      state[:valves].each do |valve|
        best = [
          best,
          new_sum + maxflow(valve, opened, min_left - 1)
        ].max
      end
    end
    best
  end
end

# Part 1
# puts maxflow('AA', Set.new, 30)

@cache2 = {}
def maxflow2(cur, opened, min_left)
  @cache2[[cur, opened, min_left]] ||= begin
    if min_left <= 0
      return maxflow('AA', opened, 26)
    end

    best = 0
    state = @state[cur]
    state[:valves].each do |valve|
      best = [best, maxflow2(valve, opened, min_left - 1)].max
    end

    if !opened.include?(cur) && state[:rate] > 0 && min_left >= 0
      opened = opened.dup
      opened.add(cur)
      min_left -= 1
      new_sum = min_left * state[:rate]

      state[:valves].each do |valve|
        best = [
          best,
          new_sum + maxflow2(valve, opened, min_left - 1)
        ].max
      end
    end
    best
  end
end

puts maxflow2('AA', Set.new, 26)
