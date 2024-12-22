require 'aoc_utils'

def main
  area = AocUtils.read_chars('Day 6/input.txt')
  guard_pos = find_guard(area)
  part2(area, guard_pos)
  guard_walk(area, guard_pos)
  puts count_occurrences(area, 'X')
end

def part2(area, guard_pos)
  area_backup = area.map(&:clone)
  possible_loops = 0
  num_hashtags = count_occurrences(area, '#')
  guard_walk(area, guard_pos)
  (0..area.length - 1).each { |i|
    (0..area[0].length - 1).each { |j|
      puts "#{i}, #{j}"
      if area[i][j] == 'X'
        area_copy = area.map(&:clone)
        area_copy[i][j] = '#'
        if guard_walk_with_loop_detection(area_copy, guard_pos, num_hashtags)
          possible_loops += 1
        end
      end
    }
  }
  area = area_backup
  puts possible_loops
end

def guard_walk_with_loop_detection(area, pos, num_hashtags)
  direction = [-1, 0]
  x, y = pos
  count_turns = 0
  while true
    if count_turns > num_hashtags * 5
      return true
    end
    if x + direction[0] < 0 || x + direction[0] >= area.length || y + direction[1] < 0 || y + direction[1] >= area[0].length
      break
    end
    if area[x + direction[0]][y + direction[1]] == '#'
      direction = turn_right(direction)
      count_turns += 1
      next
    end
    x, y = [x + direction[0], y + direction[1]]
  end
  false
end

def count_occurrences(area, char)
  count = 0
  area.each do |row|
    row.each do |cell|
      if cell == char
        count += 1
      end
    end
  end
  count
end

def guard_walk(area, pos)
  direction = [-1, 0]
  x, y = pos
  while true
    area[x][y] = 'X'
    if x + direction[0] < 0 || x + direction[0] >= area.length || y + direction[1] < 0 || y + direction[1] >= area[0].length
      break
    end
    if area[x + direction[0]][y + direction[1]] == '#'
      direction = turn_right(direction)
      next
    end
    x, y = [x + direction[0], y + direction[1]]
  end
  x_guard, y_guard = pos
  area[x_guard][y_guard] = '^'
end

def turn_right(direction)
  case direction
  when [-1, 0]
    direction = [0, 1]
  when [0, 1]
    direction = [1, 0]
  when [1, 0]
    direction = [0, -1]
  when [0, -1]
    direction = [-1, 0]
  else
    throw "Invalid direction"
  end
  direction
end

def find_guard(area)
  area.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      if cell == '^'
        return [x, y]
      end
    end
  end
end

main