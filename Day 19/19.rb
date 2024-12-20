require 'aoc_utils'

def main
  available_parts, combinations = AocUtils.read_two_parts('Day 19/input.txt', 'String', 'String')
  available_parts.flatten!
  available_parts.sort_by! { |part| part.length }
  combinations.flatten!
  @memory = Hash.new
  #fill_memory(available_parts)
  #available_parts.sort_by! { |part| part.length }
  puts find_valid_combinations(available_parts, combinations)
end

def fill_memory(available_parts)
  available_parts.each do |part|
    @memory[part] = 1
  end
  available_parts.each do |part|
    check_combination_possible2(available_parts, part)
  end
end

def find_valid_combinations(available_parts, combinations)
  possible_combinations = 0
  combinations.each_with_index do |combination, index|
    possible_combinations += check_combination_possible(available_parts, combination)
  end
  possible_combinations
end

def check_combination_possible(available_parts, combination)
  if combination.length == 0
    1
  elsif @memory.has_key?(combination)
    @memory[combination]
  else
    combinations = 0
    (0..combination.length - 1).each { |i|
      if available_parts.include?(combination[0..i])
        combinations += check_combination_possible(available_parts, combination[i + 1..-1])
      end
    }
    @memory[combination] = combinations
    combinations
  end
end

main