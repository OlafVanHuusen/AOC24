require 'aoc_utils'

def main
  constraints, rows = AocUtils.read_two_parts('Day 5/input.txt', "Integer", "Integer")
  must_be_before = calculate_must_be_before(constraints)
  puts calculate_part1(must_be_before, rows)
end

def calculate_part1(must_be_before, rows)
  sum = 0
  rows.each do |row|
    sum += calculate_row(must_be_before, row)
  end
  sum
end

def calculate_row(must_be_before, row)
  row.each_with_index do |int, index|
    row[0..index].each do |int2|
      unless must_be_before.include?(int)
        next
      end
      if must_be_before[int].include?(int2)
        return 0
      end
    end
  end
  row[(row.length / 2).floor]
end

def calculate_must_be_before(constraints)
  must_be_before = Hash.new
  constraints.each do |constraint|
    must_be_before[constraint[0]] = [] if must_be_before[constraint[0]].nil?
    must_be_before[constraint[0]].push(constraint[1])
  end
  must_be_before
end

main