# frozen_string_literal: true

require 'debug'
require 'set'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

# Example:
# Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
blueprints = lines.map do |line|
  _, robots_string = line.split(': ')
  robots_strings = robots_string.split('. ')
  robots = {}
  robots_strings.each do |robot_string|
    type, costs = robot_string.split(' robot costs ')
    robots[type.delete_prefix('Each ').to_sym] = costs
      .scan(/(\d+) (\w+)/)
      .map { [_1[1].to_sym, _1[0].to_i] }.to_h
  end
  robots
end

supplies = {
  ore: 0,
  clay: 0,
  obsidian: 0,
  geode: 0
}

robots = {
  ore: 1,
  clay: 0,
  obsidian: 0,
  geode: 0
}

pp "blueprints: #{blueprints}"

@tick = {}
@largest = Hash.new { 0 }

def tick(path, minutes, supplies, robots, blueprint, skipped = [])
  geo_ratio = supplies[:geode]
  return nil if geo_ratio + 1 < @largest[minutes]

  @largest[minutes] = geo_ratio if geo_ratio > @largest[minutes]
  # @tick[[minutes, supplies, robots, blueprint, skipped]] ||= begin

  # build Available robots
  afordable_robots = blueprint.select do |type, cost|
    # if we didn't buy it last time (when we could have), we won't buy it this time
    cost.all? { |resource, count| supplies[resource] >= count } &&
      !skipped.include?(type) &&
      robots[type] < @max_required[type]
  end
  if afordable_robots[:geode] # if we can afford a geode, we don't need anything else
    afordable_robots = {geode: afordable_robots[:geode]}
  end

  # puts "#{path.join()} - Min: #{minutes} S: #{supplies} and R: #{robots}. Could: #{afordable_robots.keys}"

  # collect all supplies
  robots.each do |type, count|
    next if count.zero?

    supplies[type] += count
  end

  if minutes >= 32
    # puts "finished run with geodes: #{supplies[:geode]}"
    return {m: minutes, s: supplies, r: robots, p: path}
  end

  # for each afordable robot
  paths = afordable_robots.map do |type, cost|
    new_supplies = supplies.dup
    new_robots = robots.dup
    # build one
    # puts "Building Robot #{type}, costing #{cost}"
    new_robots[type] += 1

    # pay for it
    cost.each do |resource, count|
      new_supplies[resource] -= count
    end

    # tick
    tick(path + [type.to_s[0..1]], minutes + 1, new_supplies, new_robots, blueprint)
  end.compact

  paths << tick(path + ['.'], minutes + 1, supplies.dup, robots.dup, blueprint, afordable_robots.keys) unless afordable_robots[:geode]
  paths
  # end
end

options = blueprints.first(3).map.with_index(1) do |blueprint, idx|
  puts "Checking blueprint #{idx}: #{blueprint}"
  current_supplies = supplies.dup
  current_robot = robots.dup
  @tick = {}
  @largest = Hash.new { 0 }
  @max_required = {
    ore: blueprint.map { _1[1][:ore] }.compact.max,
    clay: blueprint.map { _1[1][:clay] }.compact.max,
    obsidian: blueprint.map { _1[1][:obsidian] }.compact.max,
    geode: 999
  }

  best = tick([], 1, current_supplies, current_robot, blueprint).flatten.compact.max_by { _1[:s][:geode] }
  [
    idx,
    best[:s][:geode],
    idx * best[:s][:geode],
    best
  ]
end

pp options

pp options.map { _1[1] }.inject(&:*)
