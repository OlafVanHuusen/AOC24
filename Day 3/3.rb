require 'aoc_utils'

def main
  input = File.read('Day 3/input.txt')
  #puts part1(input)
  puts part2(input)
end

def part1(input)
  regex = /mul\((\d{1,3}),(\d{1,3})\)/
  matches = input.scan(regex)
  matches.map { |x, y| x.to_i * y.to_i }.sum
end

def part2(input)
  regex = /(do\(\))|(mul\((\d{1,3}),(\d{1,3})\))|(don't\(\))/
  matches = input.scan(regex)
  enabled = true
  sum = 0

  matches.each do |match|
    if match[0] == 'do()'
      enabled = true
    elsif match[4] == "don't()"
      enabled = false
    elsif match[1].start_with?('mul')
      if enabled
        sum += match[2].to_i * match[3].to_i
      end
    end
  end
  sum
end

main