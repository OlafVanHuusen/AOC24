require 'aoc_utils'

def main
  input = AocUtils.read_ints('Day 7/input.txt')
  results, operands = [], []
  input.each do |line|
    results << line[0]
    operands << line[1..-1]
  end
  @combinations = Array.new(15)
  (0..14).each do |i|
    @combinations[i] = create_combinations(i + 1)
  end
  possible_equations = []
  (0..results.length - 1).each do |i|
    puts i
    possible_equations << results[i] if is_equation_possible(results[i], operands[i])
  end
  puts possible_equations.reduce(:+)
end

def is_equation_possible(result, operands)
  #combinations = create_combinations(operands.length)
  combinations = @combinations[operands.length - 1]
  possible = false
  combinations.each do |combination|
    if calculate_result(result, operands, combination)
      possible = true
      break
    end
  end
  possible
end

def calculate_result(result, operands, combination)
  temp = operands[0]
  (0..operands.length - 2).each do |i|
    temp = calculate(temp, operands[i + 1], combination[i])
    if temp > result
      return false
    end
  end
  temp == result
end

def calculate(operand1, operand2, operator)
  case operator
  when '+'
    operand1 + operand2
  when '*'
    operand1 * operand2
  when '||'
    (operand1.to_s + operand2.to_s).to_i
  end
end

def create_combinations(number_of_operands)
  operands = %w[+ * ||]
  operands.repeated_permutation(number_of_operands - 1).to_a
end

main