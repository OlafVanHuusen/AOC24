def main
  warehouse, robot, moves = parse_input('Day 15/input.txt')
  warehouse, robot, moves = alter_input_part_2(warehouse, robot, moves)
  print_warehouse(warehouse)
  make_moves(warehouse, robot, moves)
  print_warehouse(warehouse)
  boxes = find_boxes(warehouse)
  puts calc_total_gps_value(boxes)
end

def alter_input_part_2(warehouse, robot, moves)
  warehouse.each do |row|
    row.map! { |cell|
      case cell
      when '#'
        %w[# #]
      when '.'
        %w[. .]
      when 'O'
        %w[\[ \]]
      when '@'
        %w[@ .]
      end
    }
    row.flatten!
  end
  robot[1] *= 2
  [warehouse, robot, moves]
end

def print_warehouse(warehouse)
  warehouse.each do |row|
    puts row.join
  end
end

def calc_total_gps_value(boxes)
  boxes.map { |box| gps_value_of_box(box) }.sum
end

def gps_value_of_box(box)
  box[0] * 100 + box[1]
end

def find_boxes(warehouse)
  boxes = []
  warehouse.each_with_index do |row, index1|
    row.each_with_index do |cell, index2|
      if cell == '['
        boxes << [index1, index2]
      end
    end
  end
  boxes
end

def make_moves(warehouse, robot, moves)
  moves.each do |move|
    case move
    when '^'
      case warehouse[robot[0] - 1][robot[1]]
      when '.'
        warehouse[robot[0]][robot[1]] = '.'
        robot[0] -= 1
        warehouse[robot[0]][robot[1]] = '@'
      when '[' , ']'
        pushPossible = pushing_box_possible(warehouse, [robot[0] - 1, robot[1]], 'up')
        if pushPossible
          push_box(warehouse, [robot[0] - 1, robot[1]], 'up')
          warehouse[robot[0]][robot[1]] = '.'
          robot[0] -= 1
          warehouse[robot[0]][robot[1]] = '@'
        end
      when '#'
        next
      end
    when 'v'
      case warehouse[robot[0] + 1][robot[1]]
      when '.'
        warehouse[robot[0]][robot[1]] = '.'
        robot[0] += 1
        warehouse[robot[0]][robot[1]] = '@'
      when '[' , ']'
        pushPossible = pushing_box_possible(warehouse, [robot[0] + 1, robot[1]], 'down')
        if pushPossible
          push_box(warehouse, [robot[0] + 1, robot[1]], 'down')
          warehouse[robot[0]][robot[1]] = '.'
          robot[0] += 1
          warehouse[robot[0]][robot[1]] = '@'
        end
      when '#'
        next
      end
    when '<'
      case warehouse[robot[0]][robot[1] - 1]
      when '.'
        warehouse[robot[0]][robot[1]] = '.'
        robot[1] -= 1
        warehouse[robot[0]][robot[1]] = '@'
      when ']'
        pushedBox = attempt_to_push_box(warehouse, [robot[0], robot[1] - 1], 'left')
        if pushedBox
          warehouse[robot[0]][robot[1]] = '.'
          robot[1] -= 1
          warehouse[robot[0]][robot[1]] = '@'
        end
      when '['
        puts "ERROR"
      when '#'
        next
      end
    when '>'
      case warehouse[robot[0]][robot[1] + 1]
      when '.'
        warehouse[robot[0]][robot[1]] = '.'
        robot[1] += 1
        warehouse[robot[0]][robot[1]] = '@'
      when '['
        pushedBox = attempt_to_push_box(warehouse, [robot[0], robot[1] + 1], 'right')
        if pushedBox
          warehouse[robot[0]][robot[1]] = '.'
          robot[1] += 1
          warehouse[robot[0]][robot[1]] = '@'
        end
      when ']'
        puts "ERROR"
      when '#'
        next
      end
    end
  end
end

def push_box(warehouse, boxCoordinate, direction, coming_from_side = false)
  own_cell = warehouse[boxCoordinate[0]][boxCoordinate[1]]
  case direction
  when 'up'
    case warehouse[boxCoordinate[0] - 1][boxCoordinate[1]]
    when '.'
      warehouse[boxCoordinate[0] - 1][boxCoordinate[1]] = warehouse[boxCoordinate[0]][boxCoordinate[1]]
      warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
    when '[' , ']'
      push_box(warehouse, [boxCoordinate[0] - 1, boxCoordinate[1]], 'up')
      warehouse[boxCoordinate[0] - 1][boxCoordinate[1]] = warehouse[boxCoordinate[0]][boxCoordinate[1]]
      warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
    end
    if coming_from_side
      return
    end
    case own_cell
    when '['
      push_box(warehouse, [boxCoordinate[0], boxCoordinate[1] + 1], 'up', true)
    when ']'
      push_box(warehouse, [boxCoordinate[0], boxCoordinate[1] - 1], 'up', true)
    end
  when 'down'
    case warehouse[boxCoordinate[0] + 1][boxCoordinate[1]]
    when '.'
      warehouse[boxCoordinate[0] + 1][boxCoordinate[1]] = warehouse[boxCoordinate[0]][boxCoordinate[1]]
      warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
    when '[' , ']'
      push_box(warehouse, [boxCoordinate[0] + 1, boxCoordinate[1]], 'down')
      warehouse[boxCoordinate[0] + 1][boxCoordinate[1]] = warehouse[boxCoordinate[0]][boxCoordinate[1]]
      warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
    end
    if coming_from_side
      return
    end
    case own_cell
    when '['
      push_box(warehouse, [boxCoordinate[0], boxCoordinate[1] + 1], 'down', true)
    when ']'
      push_box(warehouse, [boxCoordinate[0], boxCoordinate[1] - 1], 'down', true)
    end
  end
end

def attempt_to_push_box(warehouse, boxCoordinate, direction)
  case direction
  when 'left'
    case warehouse[boxCoordinate[0]][boxCoordinate[1] - 1]
    when '.'
      warehouse[boxCoordinate[0]][boxCoordinate[1] - 1] = warehouse[boxCoordinate[0]][boxCoordinate[1]]
      warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
      return true
    when '[' , ']'
      boxPushable = attempt_to_push_box(warehouse, [boxCoordinate[0], boxCoordinate[1] - 1], 'left')
      if boxPushable
        warehouse[boxCoordinate[0]][boxCoordinate[1] - 1] = warehouse[boxCoordinate[0]][boxCoordinate[1]]
        warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
        return true
      else
        return false
      end
    when '#'
      return false
    end
  when 'right'
    case warehouse[boxCoordinate[0]][boxCoordinate[1] + 1]
    when '.'
      warehouse[boxCoordinate[0]][boxCoordinate[1] + 1] = warehouse[boxCoordinate[0]][boxCoordinate[1]]
      warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
      return true
    when ']' , '['
      boxPushable = attempt_to_push_box(warehouse, [boxCoordinate[0], boxCoordinate[1] + 1], 'right')
      if boxPushable
        warehouse[boxCoordinate[0]][boxCoordinate[1] + 1] = warehouse[boxCoordinate[0]][boxCoordinate[1]]
        warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
        return true
      else
        return false
      end
    when '#'
      return false
    end
  else
    puts "Invalid direction"
  end
  false
end

#only necessary for special case of up or down
def pushing_box_possible(warehouse, boxCoordinate, direction, coming_from_side = false)
  case direction
  when 'up'
    self_pushable = false
    case warehouse[boxCoordinate[0] - 1][boxCoordinate[1]]
    when '.'
      self_pushable = true
    when '[' , ']'
      self_pushable = pushing_box_possible(warehouse, [boxCoordinate[0] - 1, boxCoordinate[1]], 'up')
    when '#'
      self_pushable = false
    end
    neighbor_pushable = false
    if coming_from_side
      neighbor_pushable = true
    else
      case warehouse[boxCoordinate[0]][boxCoordinate[1]]
      when '['
        neighbor_pushable = pushing_box_possible(warehouse, [boxCoordinate[0], boxCoordinate[1] + 1], 'up', true)
      when ']'
        neighbor_pushable = pushing_box_possible(warehouse, [boxCoordinate[0], boxCoordinate[1] - 1], 'up', true)
      end
    end
    return self_pushable && neighbor_pushable
  when 'down'
    self_pushable = false
    case warehouse[boxCoordinate[0] + 1][boxCoordinate[1]]
    when '.'
      self_pushable = true
    when '[' , ']'
      self_pushable = pushing_box_possible(warehouse, [boxCoordinate[0] + 1, boxCoordinate[1]], 'down')
    when '#'
      self_pushable = false
    end
    neighbor_pushable = false
    if coming_from_side
      neighbor_pushable = true
    else
      case warehouse[boxCoordinate[0]][boxCoordinate[1]]
      when '['
        neighbor_pushable = pushing_box_possible(warehouse, [boxCoordinate[0], boxCoordinate[1] + 1], 'down', true)
      when ']'
        neighbor_pushable = pushing_box_possible(warehouse, [boxCoordinate[0], boxCoordinate[1] - 1], 'down', true)
      end
    end
    return self_pushable && neighbor_pushable
  end
end

def parse_input(file_path)
  input = File.readlines(file_path)
  input.each { |line| line.chomp! }
  warehouseWidth = input[0].length
  warehouseHeight = 0
  robot = []
  for i in 0..input.length
    if input[i].length == 0
      warehouseHeight = i
      break
    end
  end
  warehouse = Array.new(warehouseHeight) { Array.new(warehouseWidth) }
  for i in 0..warehouseHeight - 1
    for j in 0..warehouseWidth - 1
      warehouse[i][j] = input[i][j]
      if input[i][j] == '@'
        robot = [i, j]
      end
    end
  end
  moves = []
  for i in warehouseHeight + 1..input.length - 1
    moves.concat(input[i].chars)
  end
  [warehouse, robot, moves]
end

main