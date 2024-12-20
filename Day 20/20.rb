require 'aoc_utils'

def main
  maze = AocUtils.read_chars('Day 20/input.txt')
  start, finish = find_start_and_finish(maze)
  #walls = find_walls_with_paths_on_two_sides(maze)
  calculate_distance_to_finish(maze, finish)
  base_value = maze[start[0]][start[1]]
  fast_shortcuts = calculate_fast_shortcuts(maze, 100)
  print_matrix(maze)
  puts fast_shortcuts
end

def calculate_fast_shortcuts(maze, threshold)
  fast_shortcuts = 0
  0.upto(maze.length - 1) do |x|
    0.upto(maze[0].length - 1) do |y|
      puts [x, y].inspect
      next if maze[x][y] == "#" || maze[x][y] <= threshold
      fast_shortcuts += find_reachable_cords(maze, [x, y], 20, threshold)
    end
  end
  fast_shortcuts
end

def find_reachable_cords(maze, start, max_steps, threshold)
  useful_cheats = 0
  queue = [[start, 0]]
  visited = []
  until queue.empty?
    current = queue.shift
    #puts current[0].inspect
    visited.push(current[0])
    value = maze[current[0][0]][current[0][1]]
    unless value == "#" || value == "E"
      if value + threshold + current[1] <= maze[start[0]][start[1]]
        useful_cheats += 1
      end
    end
    if current[1] >= max_steps
      next
    end
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |direction|
      new_coordinate = [current[0][0] + direction[0], current[0][1] + direction[1]]
      if new_coordinate[0] < 0 || new_coordinate[0] >= maze.length || new_coordinate[1] < 0 || new_coordinate[1] >= maze[0].length
        next
      end
      next if visited.include?(new_coordinate) || queue.any? { |element| element[0] == new_coordinate }
      queue.push([new_coordinate, current[1] + 1])
    end
  end
  useful_cheats
end

def reset_grid(grid)
  grid.each do |row|
    row.each_with_index do |cell, index|
      unless cell == '#'
        row[index] = "."
      end
    end
  end
end

def find_walls_with_paths_on_two_sides(maze)
  walls = []
  maze.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      next if cell != "#"
      next if y == 0 || y == row.length - 1 || x == 0 || x == maze.length - 1
      if [maze[x - 1][y], maze[x + 1][y], maze[x][y - 1], maze[x][y + 1]].count(".") >= 2
        walls.push([x, y])
      end
    end
  end
  walls
end

def print_matrix(matrix)
  matrix.each do |row|
    puts row.map { |cell| cell.to_s.ljust(6) }.join
  end
end

def calculate_distance_to_finish(grid, finish)
  grid[finish[0]][finish[1]] = 0
  queue = [finish]
  until queue.empty?
    current = queue.shift
    value = grid[current[0]][current[1]]
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |direction|
      new_coordinate = [current[0] + direction[0], current[1] + direction[1]]
      if new_coordinate[0] < 0 || new_coordinate[0] >= grid[0].length || new_coordinate[1] < 0 || new_coordinate[1] >= grid.length
        next
      end
      if grid[new_coordinate[0]][new_coordinate[1]] == "."
        grid[new_coordinate[0]][new_coordinate[1]] = value + 1
        queue.push(new_coordinate)
      end
    end
  end
end

def find_start_and_finish(maze)
  start = finish = nil
  maze.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      start = [x, y] if cell == 'S'
      maze[x][y] = '.' if cell == 'S'
      finish = [x, y] if cell == 'E'
      maze[x][y] = '.' if cell == 'E'
    end
  end
  [start, finish]
end

main