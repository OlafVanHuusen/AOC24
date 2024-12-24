require 'aoc_utils'

def main
  declarations, connections = AocUtils.read_two_parts('Day 24/input.txt', 'String', 'String')
  declarations.flatten!
  connections.flatten!
  wire_values = Hash.new
  declarations.each do |declaration|
    wire = declaration[0..2]
    value = declaration[4..-1].to_i
    wire_values[wire] = value
  end
  connections = format_connections(connections)
  connections = make_swaps(connections)
  calculate_wire_values(wire_values, connections)
  puts combining_output(wire_values)
end

# only a helper method to manually solve part 2
def part2(wire_values, connections)
  connections.each do |connection|
    if connection[3] == connection[1] || connection[3] == connection[2]
      puts connection[3]
    end
  end
  wire_names = wire_values.keys
  print_all_dependencies(wire_names, wire_values, connections)
end

def print_all_dependencies(wire_names, wire_values, connections)
  dependencies = Hash.new
  wire_names.each do |wire_name|
    if wire_name[0] == "z"
      dependencies[wire_name] = find_dependencies(wire_name, wire_values, connections)
    end
  end
  #dependencies.each { |key, value| puts "#{key}: #{value.size}" }
  #puts dependencies
  dependencies.each do |key, value|
    puts "#{key}: #{value.take(12).join(', ')}"
  end
end

def find_dependencies(wire_name, wire_values, connections)
  dependencies = []
  queue = [wire_name]
  until queue.empty?
    current = queue.shift
    connections.each do |connection|
      if connection[3] == current
        input1 = connection[1]
        input2 = connection[2]
        queue.push(input1)
        dependencies.push(input1)
        queue.push(input2)
        dependencies.push(input2)
      end
    end
  end
  dependencies.uniq
end

def combining_output(wire_values)
  result_string = ""
  wire_values.sort_by { |k, v| k }.reverse.each do |key, value|
    if key[0] != "z"
      break
    end
    #puts "#{key}: #{value}"
    result_string += "#{value}"
  end
  result_string.to_i(2).to_i
end

def calculate_wire_values(wire_values, connections)
  changed = true
  while changed
    changed = false
    connections.each do |connection|
      operator = connection[0]
      input1 = connection[1]
      input2 = connection[2]
      output = connection[3]
      if wire_values[output] == nil
        if wire_values[input1] != nil && wire_values[input2] != nil
          case operator
          when "AND"
            wire_values[output] = wire_values[input1] & wire_values[input2]
          when "OR"
            wire_values[output] = wire_values[input1] | wire_values[input2]
          when "XOR"
            wire_values[output] = wire_values[input1] ^ wire_values[input2]
          else
            throw "Invalid operator"
          end
          changed = true
        end
      end
    end
  end
end

def format_connections(connections)
  connections_new = []
  connections.each do |connection|
    temp = []
    parts = connection.split(" ")
    temp << parts[1]
    temp << parts[0]
    temp << parts[2]
    temp << parts[4]
    connections_new << temp
  end
  connections_new
end

main