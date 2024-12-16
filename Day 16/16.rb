def main
  maze, start, finish = parse_input('Day 16/input.txt')
  print_maze(maze)
  rotationsToFinish = Array.new(maze.length) { Array.new(maze[0].length, [-1, ["no direction"]]) }
  populate_rotations_to_finish(maze, start, finish, rotationsToFinish)
  puts calculateRotationsToFinish(rotationsToFinish, start) * 1000 + calculateStepsToFinish(rotationsToFinish, start)
  temp = get_tiles_in_perfect_paths(rotationsToFinish, start, rotationsToFinish[start[0]][start[1]][1][0])
  temp.each do |tile|
    maze[tile[0]][tile[1]] = 'X'
  end
  print_maze(maze)
  #count the tiles in pathes that are too long and add the set the number in this file here
  tiles_in_paths_that_are_too_long = 32
  replace_all_negative_ones_with_hashtags(rotationsToFinish)
  printRotationsToFinish(rotationsToFinish)
  puts
  puts
  puts temp.length - tiles_in_paths_that_are_too_long
end

def get_tiles_in_perfect_paths(rotationsToFinish, start, direction)
  tiles = [start]
  value = rotationsToFinish[start[0]][start[1]][0]
  direction_modifier = case direction
                       when 'N'
                        [-1, 0]
                       when 'E'
                         [0, 1]
                       when 'S'
                         [1, 0]
                       when 'W'
                         [0, -1]
                       when 'goal'
                         return tiles
                       else
                         puts "Invalid direction #{direction}"
                       end

  queue = [[start[0] + direction_modifier[0], start[1] + direction_modifier[1]]]
  temp = []
  until queue.empty?
    current = queue.shift
    if rotationsToFinish[current[0]][current[1]][1][0] == 'goal'
      tiles.concat(temp)
      tiles.concat([current])
      break
    end
    if rotationsToFinish[current[0]][current[1]][0] == -1
      next
    end
    if rotationsToFinish[current[0]][current[1]][0] == value - 1
      tiles.concat(temp)
      rotationsToFinish[current[0]][current[1]][1].each do |direction|
        tiles.concat(get_tiles_in_perfect_paths(rotationsToFinish, current, direction))
      end
    else
      temp.push(current)
    end
    queue.push([current[0] + direction_modifier[0], current[1] + direction_modifier[1]])
  end
  tiles.to_set.to_a
end

def calculateRotationsToFinish(rotationsToFinish, start)
  startDirection = rotationsToFinish[start[0]][start[1]][1][0]
  startRotations = startDirection == 'E' ? 0 : 1
  rotationsToFinish[start[0]][start[1]][0] + startRotations
end

def calculateStepsToFinish(rotationsToFinish, start)
  steps = 0
  current = start
  until rotationsToFinish[current[0]][current[1]][1][0] == 'goal'
    steps += 1
    case rotationsToFinish[current[0]][current[1]][1][0]
    when 'N'
      current = [current[0] - 1, current[1]]
    when 'E'
      current = [current[0], current[1] + 1]
    when 'S'
      current = [current[0] + 1, current[1]]
    when 'W'
      current = [current[0], current[1] - 1]
    end
  end
  steps
end

def replace_all_negative_ones_with_hashtags(rotationsToFinish)
  rotationsToFinish.each do |row|
    row.each do |cell|
      if cell[0] == -1
        cell[0] = '#'
      end
    end
  end
end

def printRotationsToFinish(rotationsToFinish)
  puts "\n" * 2
  rotationsToFinish.each do |row|
    row.each do |cell|
      print "#{cell[0]} "
    end
    puts
  end
end

def populate_rotations_to_finish(maze, start, finish, rotationsToFinish)
  rotationsToFinish[finish[0]][finish[1]] = [0, ["goal"]]
  queue = [[finish[0], finish[1] - 1], [finish[0] + 1, finish[1]]]
  rotationsToFinish[finish[0]][finish[1] - 1] = [0, ['E']]
  rotationsToFinish[finish[0] + 1][finish[1]] = [0, ['N']]
  until queue.empty?
    current = queue.shift
    #if current[0] == 11 && current[1] == 3
      #puts "here"
      #end
    #rotationsToFinishCopy = Marshal.load(Marshal.dump(rotationsToFinish))
    #replace_all_negative_ones_with_hashtags(rotationsToFinishCopy)
    #printRotationsToFinish(rotationsToFinishCopy)
    [[-1, 0, 'S'], [0, 1, 'W'], [1, 0, 'N'], [0, -1, 'E']].each do |direction|
      new_row = current[0] + direction[0]
      new_col = current[1] + direction[1]
      directionChar = direction[2]
      if maze[new_row][new_col] == '#'
        next
      end
      directionsToFinish = rotationsToFinish[current[0]][current[1]][1]
      rotationNeeded = directionsToFinish.include?(directionChar) ? 0 : 1
      if rotationsToFinish[new_row][new_col][0] == -1
        rotationsToFinish[new_row][new_col] = [rotationsToFinish[current[0]][current[1]][0] + rotationNeeded, [directionChar]]
        queue.push([new_row, new_col])
      elsif rotationsToFinish[new_row][new_col][0] > rotationsToFinish[current[0]][current[1]][0] + rotationNeeded
        rotationsToFinish[new_row][new_col] = [rotationsToFinish[current[0]][current[1]][0] + rotationNeeded, [directionChar]]
        queue.push([new_row, new_col])
      elsif rotationsToFinish[new_row][new_col][0] == rotationsToFinish[current[0]][current[1]][0] + rotationNeeded
        unless rotationsToFinish[new_row][new_col][1].include?(directionChar)
          rotationsToFinish[new_row][new_col][1].push(directionChar)
          queue.push([new_row, new_col])
        end
      end
    end
  end
end

def print_maze(maze)
  maze.each do |row|
    row.each do |cell|
      print "#{cell} "
    end
    puts
  end
end

def parse_input(file)
  maze = []
  start = []
  finish = []
  File.open(file).each_with_index do |line, index|
    maze << line.chomp.split('')
    start = [index, maze[index].index('S')] if maze[index].include?('S')
    finish = [index, maze[index].index('E')] if maze[index].include?('E')
  end
  [maze, start, finish]
end

main