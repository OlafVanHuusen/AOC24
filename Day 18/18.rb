require 'aoc_utils'

def main
  coordinates = AocUtils.read_ints('Day 18/input.txt')
  max_coordinate = 70
  grid = Array.new(max_coordinate + 1) { Array.new(max_coordinate + 1, ".") }
  do_steps(grid, coordinates, 1024)
  calculate_distance_to_exit(grid)
  #print_grid(grid)
  #puts grid[0][0]
  part2(grid, coordinates)
end

def part2(grid, coordinates)
  new_coordinate = nil
  while true
    reset_grid(grid)
    new_coordinate = coordinates[0]
    do_steps(grid, coordinates, 1)
    calculate_distance_to_exit(grid)
    if grid[0][0] == '.'
      break
    end
  end
  puts new_coordinate
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

def calculate_distance_to_exit(grid)
  grid[grid.length - 1][grid[0].length - 1] = 0
  queue = [[grid.length - 1, grid[0].length - 1]]
  until queue.empty?
    current = queue.shift
    value = grid[current[0]][current[1]]
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |direction|
      new_coordinate = [current[0] + direction[0], current[1] + direction[1]]
      if new_coordinate[0] < 0 || new_coordinate[0] >= grid.length || new_coordinate[1] < 0 || new_coordinate[1] >= grid[0].length
        next
      end
      if grid[new_coordinate[0]][new_coordinate[1]] == "."
        grid[new_coordinate[0]][new_coordinate[1]] = value + 1
        queue.push(new_coordinate)
      end
    end
  end
end

def print_grid(grid)
  grid.each do |row|
    puts row.map { |cell| cell.to_s.ljust(4) }.join
  end
end

def do_steps(grid, coordinates, amount_of_steps)
  amount_of_steps.times do
    coordinate = coordinates.shift
    grid[coordinate[1]][coordinate[0]] = "#"
  end
end

main