require "aoc_utils"

def main
  @register, programRaw = AocUtils.read_two_parts('Day 17/input.txt', "Integer", "Integer")
  @register.map! { |number| number[0] }
  #@register[0] = 0b011_000_000_010_101_000_000_000_000_011_000_000_000_000_000_000
  @out = []
  @program = []
  programRaw[0].each_slice(2) { |tuple| @program.push(tuple) }
  #run_program(@program)
  #puts @out.join(",")
  puts part2
  #puts binary_to_number([0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,7])
end

def part2
  @start_binary = [0] * @program.flatten.length
  target_array = @program.flatten.reverse
  puts calc_number(target_array, 0)
end

def binary_to_number(binary)
  binary.map {|num| num.to_s(2).rjust(3, '0')}.join.to_i(2)
end

def calc_number(target_array, depths)
  if depths == @start_binary.length
    return binary_to_number(@start_binary)
  end
  (0..7).each do |i|
    @start_binary[depths] = i
    @out = []
    @register[0] = binary_to_number(@start_binary)
    run_program(@program)
    if @out.reverse[0..depths] == target_array[0..depths]
      result_recursive = calc_number(target_array, depths + 1)
      if result_recursive != -1
        return result_recursive
      end
    end
  end
  -1
end

def run_program(program)
  @instruction_pointer = 0
  while @instruction_pointer < program.length
    instruction = program[@instruction_pointer]
    opcode = instruction[0]
    operand = instruction[1]
    execute_instruction(opcode, operand)
  end
end

def execute_instruction(opcode, operand)
  case opcode
  when 0
    adv(operand)
  when 1
    bxl(operand)
  when 2
    bst(operand)
  when 3
    jnz(operand)
  when 4
    bxc(operand)
  when 5
    out(operand)
  when 6
    bdv(operand)
  when 7
    cdv(operand)
  else
    puts "Invalid opcode #{opcode}"
  end
end

def getComboOperand(number)
  case number
  when 0..3
    return number
  when 4
    @register[0]
  when 5
    @register[1]
  when 6
    @register[2]
  else
    throw "Invalid operand #{number}"
  end
end

def adv(operand)
  @register[0] = (@register[0] / (2 ** getComboOperand(operand))).floor
  @instruction_pointer += 1
end

def bxl(operand)
  @register[1] = @register[1] ^ operand
  @instruction_pointer += 1
end

def bst(operand)
  @register[1] = getComboOperand(operand) % 8
  @instruction_pointer += 1
end

def jnz(operand)
  if @register[0] == 0
    @instruction_pointer += 1
  else
    @instruction_pointer = operand / 2
  end
end

def bxc(operand)
  @register[1] = @register[1] ^ @register[2]
  @instruction_pointer += 1
end

def out(operand)
  @out.push(getComboOperand(operand) % 8)
  @instruction_pointer += 1
end

def bdv(operand)
  @register[1] = (@register[0] / (2 ** getComboOperand(operand))).floor
  @instruction_pointer += 1
end

def cdv(operand)
  @register[2] = (@register[0] / (2 ** getComboOperand(operand))).floor
  @instruction_pointer += 1
end

main