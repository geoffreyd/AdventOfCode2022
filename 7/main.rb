# frozen_string_literal: true

require 'debug'

path = './input.txt'
lines = IO.readlines(path, chomp: true)

current_dir = ""

tree = {
  "/" => {}
}

dirs = Hash.new(0)

lines.each do |line|
  case line
  when /\$ cd ([\w.]+)/
    pp "cd #{current_dir}/#{$1}"
    if $1 == ".."
      # pp "going from #{current_dir} to #{current_dir.split("/")[0..-2].join("/")}"
      current_dir = current_dir.split("/")[0..-2].join("/")
    else
      current_dir = File.join(current_dir, $1)
    end
    tree[current_dir] ||= 0
  when /\$ ls/
    next
  when /dir (\w+)/
    pp "dir #{current_dir}/#{$1}"
    # tree[current_dir][$1] = {}
  when /(\d+) (.*)/
    # dirs[current_dir] += $1.to_i
    this_dir = ''
    dirs[this_dir] += $1.to_i
    current_dir.split('/').each do |dir|
      this_dir = this_dir + '/' + dir
      dirs[this_dir] += $1.to_i
    end
    tree[current_dir + '/' + $2] = $1.to_i
  end
end

# pp tree
# pp "---"
pp dirs

things = dirs.map do |k, v|
  total = dirs[k]
  total <= 100000 ? total : 0
end.flatten

pp "----"
# pp things.sum

### Part 2

FULL = 70000000
NEEDED = 30000000
# CURRENT = dirs[""]
CURRENT = 43984248
to_remove = CURRENT - NEEDED

pp "Using #{CURRENT} of #{FULL}"
pp "We need to remove #{to_remove}"

candidates = dirs.select do |k, v|
  v >= to_remove
end

sizes = dirs.each_pair.sort_by { _2 }
pp "---"
pp sizes
pp "---"

answer = sizes.first(10)

pp answer
