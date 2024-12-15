def main
  warehouse, robot, moves = parse_input('Day 15/testinput2.txt')
  print_warehouse(warehouse)
  make_moves(warehouse, robot, moves)
  print_warehouse(warehouse)
  boxes = find_boxes(warehouse)
  puts calc_total_gps_value(boxes)
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
      if cell == 'O'
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
      when 'O'
        pushedBox = attempt_to_push_box(warehouse, [robot[0] - 1, robot[1]], 'up')
        if pushedBox
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
      when 'O'
        pushedBox = attempt_to_push_box(warehouse, [robot[0] + 1, robot[1]], 'down')
        if pushedBox
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
      when 'O'
        pushedBox = attempt_to_push_box(warehouse, [robot[0], robot[1] - 1], 'left')
        if pushedBox
          warehouse[robot[0]][robot[1]] = '.'
          robot[1] -= 1
          warehouse[robot[0]][robot[1]] = '@'
        end
      when '#'
        next
      end
    when '>'
      case warehouse[robot[0]][robot[1] + 1]
      when '.'
        warehouse[robot[0]][robot[1]] = '.'
        robot[1] += 1
        warehouse[robot[0]][robot[1]] = '@'
      when 'O'
        pushedBox = attempt_to_push_box(warehouse, [robot[0], robot[1] + 1], 'right')
        if pushedBox
          warehouse[robot[0]][robot[1]] = '.'
          robot[1] += 1
          warehouse[robot[0]][robot[1]] = '@'
        end
      when '#'
        next
      end
    end
  end
end

def attempt_to_push_box(warehouse, boxCoordinate, direction)
  case direction
  when 'up'
    case warehouse[boxCoordinate[0] - 1][boxCoordinate[1]]
    when '.'
      warehouse[boxCoordinate[0] - 1][boxCoordinate[1]] = 'O'
      warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
      return true
    when 'O'
      boxPushable = attempt_to_push_box(warehouse, [boxCoordinate[0] - 1, boxCoordinate[1]], 'up')
      if boxPushable
        warehouse[boxCoordinate[0] - 1][boxCoordinate[1]] = 'O'
        warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
        return true
      else
        return false
      end
    when '#'
      return false
    end
  when 'down'
    case warehouse[boxCoordinate[0] + 1][boxCoordinate[1]]
    when '.'
      warehouse[boxCoordinate[0] + 1][boxCoordinate[1]] = 'O'
      warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
      return true
    when 'O'
      boxPushable = attempt_to_push_box(warehouse, [boxCoordinate[0] + 1, boxCoordinate[1]], 'down')
      if boxPushable
        warehouse[boxCoordinate[0] + 1][boxCoordinate[1]] = 'O'
        warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
        return true
      else
        return false
      end
    when '#'
      return false
    end
  when 'left'
    case warehouse[boxCoordinate[0]][boxCoordinate[1] - 1]
    when '.'
      warehouse[boxCoordinate[0]][boxCoordinate[1] - 1] = 'O'
      warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
      return true
    when 'O'
      boxPushable = attempt_to_push_box(warehouse, [boxCoordinate[0], boxCoordinate[1] - 1], 'left')
      if boxPushable
        warehouse[boxCoordinate[0]][boxCoordinate[1] - 1] = 'O'
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
      warehouse[boxCoordinate[0]][boxCoordinate[1] + 1] = 'O'
      warehouse[boxCoordinate[0]][boxCoordinate[1]] = '.'
      return true
    when 'O'
      boxPushable = attempt_to_push_box(warehouse, [boxCoordinate[0], boxCoordinate[1] + 1], 'right')
      if boxPushable
        warehouse[boxCoordinate[0]][boxCoordinate[1] + 1] = 'O'
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