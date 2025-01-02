def main
  @matrix = parse_input(File.read('nytis_executor/input.txt'))
  @registers = { '🟨' => 0, '🟩' => 0, '🟦' => 0, '🟪' => 0 }
  @instruction_pointer = [0, 0]
  @direction = 'down'
  @output = []
  @halted = false
  @memory = Array.new(256, 0)
  run
end

def parse_input(input)
  matrix = []
  input.each_line do |line|
    matrix << line.strip.chars.filter { |char| char != ' ' }
  end
  matrix
end

def run
  while true
    @instruction = get_instruction
    update_instruction_pointer
    hr_instruction = human_readable(@instruction)
    execute_instruction(hr_instruction)
    break if @halted
  end
  puts @output.join
end

def execute_instruction(hr_instruction)
  #puts hr_instruction
  #puts "output: #{@output.join}"
  send(hr_instruction)
end

def update_instruction_pointer
  case @direction
  when 'down'
    @instruction_pointer[0] += 4
  when 'up'
    @instruction_pointer[0] -= 4
  when 'right'
    @instruction_pointer[1] += 4
  when 'left'
    @instruction_pointer[1] -= 4
  else
    raise 'Invalid direction'
  end
end

def get_instruction
  case @direction
  when 'down'
    instruction = (0..3).map { |i| @matrix[@instruction_pointer[0] + i][@instruction_pointer[1]] }
  when 'up'
    instruction = (0..3).map { |i| @matrix[@instruction_pointer[0] - i][@instruction_pointer[1]] }
  when 'right'
    instruction = (0..3).map { |i| @matrix[@instruction_pointer[0]][@instruction_pointer[1] + i] }
  when 'left'
    instruction = (0..3).map { |i| @matrix[@instruction_pointer[0]][@instruction_pointer[1] - i] }
  else
    raise 'Invalid direction'
  end
  instruction.join
end

def human_readable(instruction)
  hr = ""
  (0..3).each do |i|
    matches = INSTRUCTION_MAP.filter { |k, v| k.start_with?(instruction[0..i]) }
    if matches.length == 1
      hr = matches.values[0]
      break
    end
  end
  if hr.include?('/')
    if instruction[3] == '🟨' || instruction[3] == '🟩'
      hr = hr.split('/')[0]
    else
      hr = hr.split('/')[1]
    end
  end
  if hr == ""
    #puts "Output: #{@output}"
    raise "Invalid instruction: #{instruction}"
  end
  hr
end

@square_to_digit = {
  '🟨' => 0,
  '🟩' => 1,
  '🟦' => 2,
  '🟪' => 3
}

@digit_to_square = {
  0 => '🟨',
  1 => '🟩',
  2 => '🟦',
  3 => '🟪'
}

INSTRUCTION_MAP = {
  '🟨🟨🟨🟨' => 'nop',
  '🟨🟨🟨🟩' => 'halt',
  '🟨🟨🟨🟦' => 'turn_right',
  '🟨🟨🟨🟪' => 'turn_left',
  '🟨🟨🟩' => 'write_output',
  '🟨🟩' => 'greater_than/maximum',
  '🟨🟦' => 'inequality',
  '🟨🟪' => 'equality',
  '🟩🟨' => 'add',
  '🟩🟩' => 'add_immediate',
  '🟩🟦' => 'subtract',
  '🟩🟪' => 'subtract_immediate',
  '🟦🟨' => 'and/exclusive_or',
  '🟦🟩' => 'logical_right_shift/logical_left_shift',
  '🟦🟦🟨' => 'negation',
  '🟦🟦🟩' => 'reverse',
  '🟦🟦🟦' => 'jump_row',
  '🟦🟦🟪' => 'jump_column',
  '🟦🟪' => 'conditional_jump_row/conditional_jump_column',
  '🟪🟨' => 'move',
  '🟪🟩' => 'swap',
  '🟪🟦' => 'load_memory',
  '🟪🟪' => 'write_memory'
}

def nop

end

def halt
  @halted = true
end

def turn_right
  @direction = case @direction
               when 'down' then 'left'
               when 'left' then 'up'
               when 'up' then 'right'
               when 'right' then 'down'
               else
                 # type code here
               end
end

def turn_left
  @direction = case @direction
               when 'down' then 'right'
               when 'right' then 'up'
               when 'up' then 'left'
               when 'left' then 'down'
               else
                 # type code here
               end
end

def write_output
  @output << @registers[@instruction[3]]
end

def greater_than
  dest = @instruction[3] == '🟨' ? '🟦' : '🟪'
  src = @instruction[2]
  @registers[dest] = @registers[dest] > @registers[src] ? 1 : 0
end

def maximum
  dest = @instruction[3]
  src = @instruction[2]
  @registers[dest] = [@registers[dest], @registers[src]].max
end

def inequality
  dest = @instruction[3]
  src = @instruction[2]
  @registers[dest] = @registers[dest] != @registers[src] ? 1 : 0
end

def equality
  dest = @instruction[3]
  src = @instruction[2]
  @registers[dest] = @registers[dest] == @registers[src] ? 1 : 0
end

def add
  dest = @instruction[3]
  src = @instruction[2]
  @registers[dest] = (@registers[dest] + @registers[src]) % 256
end

def add_immediate
  dest = @instruction[3]
  src = @square_to_digit[@instruction[2]]
  @registers[dest] = (@registers[dest] + src) % 256
end

def subtract
  dest = @instruction[3]
  src = @instruction[2]
  @registers[dest] = (@registers[dest] - @registers[src]) % 256
  if @registers[dest] < 0
    @registers[dest] += 256
  end
end

def subtract_immediate
  dest = @instruction[3]
  src = @square_to_digit[@instruction[2]]
  @registers[dest] = (@registers[dest] - src) % 256
  if @registers[dest] < 0
    @registers[dest] += 256
  end
end

def and
  dest = @instruction[3] == '🟨' ? '🟦' : '🟪'
  src = @instruction[2]
  @registers[dest] = (@registers[dest] & @registers[src]) % 256
end

def exclusive_or
  dest = @instruction[3]
  src = @instruction[2]
  @registers[dest] = (@registers[dest] ^ @registers[src]) % 256
end

def logical_right_shift
  dest = @instruction[3] == '🟨' ? '🟦' : '🟪'
  src = @instruction[2]
  @registers[dest] = (@registers[dest] >> @registers[src]) % 256
end

def logical_left_shift
  dest = @instruction[3]
  src = @instruction[2]
  @registers[dest] = (@registers[dest] << @registers[src]) % 256
end

def negation
  dest = @instruction[3]
  @registers[dest] = ~@registers[dest]
  if @registers[dest] < 0
    @registers[dest] += 256
  end
end

def reverse
  dest = @instruction[3]
  @registers[dest] = @registers[dest].to_s(2).rjust(8, '0').reverse.to_i(2)
end

def jump_row
  dest = @instruction[3]
  @instruction_pointer[0] = @registers[dest]
end

def jump_column
  dest = @instruction[3]
  @instruction_pointer[1] = @registers[dest]
end

def conditional_jump_row
  dest = @instruction[3] == '🟨' ? '🟦' : '🟪'
  src = @instruction[2]
  @instruction_pointer[0] = @registers[dest] if @registers[src] != 0
end

def conditional_jump_column
  dest = @instruction[3]
  src = @instruction[2]
  @instruction_pointer[1] = @registers[dest] if @registers[src] != 0
end

def move
  src = @instruction[2]
  dest = @instruction[3]
  @registers[dest] = @registers[src]
end

def swap
  src = @instruction[2]
  dest = @instruction[3]
  @registers[dest], @registers[src] = @registers[src], @registers[dest]
end

def load_memory
  src = @instruction[2]
  dest = @instruction[3]
  @registers[src] = @memory[@registers[dest]]
end

def write_memory
  src = @instruction[2]
  dest = @instruction[3]
  @memory[@registers[dest]] = @registers[src]
end

private

#helper methods

def squares_to_int(four_bit_square_number)
  four_bit_square_number.chars.map { |square| @square_to_digit[square] }.join.to_i(4)
end

def int_to_squares(number)
  number.to_s(4).rjust(4, '0').chars.map { |digit| @digit_to_square[digit.to_i] }.join
end

main