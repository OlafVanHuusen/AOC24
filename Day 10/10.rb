def main
  matrix = File.readlines('Day 10/input.txt').map { |line| line.chars.map{ |char| char >= '0' && char <= '9' ? char.to_i : -1}}.each do |row| row.delete(-1) end
  trailheads = find_trailheads(matrix)
  #computation for part 1
  puts "Sum of trails for all trailheads:" + trailheads.map { |trailhead| all_reached_trailends_for_coordinate(matrix, trailhead).size }.reduce(:+).to_s
  #computation for part 2
  puts "Number of ways to all trailends for all trailheads:" + trailheads.map { |trailhead| number_of_ways_to_all_trailends_for_coordinate(matrix, trailhead) }.reduce(:+).to_s
end

def find_trailheads(matrix)
  trailheads = []
  matrix.each_with_index do |row, i|
    row.each_with_index do |value, j|
      trailheads << [i, j] if value == 0
    end
  end
  trailheads
end

def all_reached_trailends_for_coordinate(matrix, coordinate)
  if matrix[coordinate[0]][coordinate[1]] == 9 then return Set.new([coordinate]) end
  neighbours = get_neighbours(matrix, coordinate)
  reachedTrailends = Set.new
  value = matrix[coordinate[0]][coordinate[1]]
  neighbours.each do |neighbour|
    reachedTrailends.merge(all_reached_trailends_for_coordinate(matrix, neighbour)) if matrix[neighbour[0]][neighbour[1]] == value + 1
  end
  reachedTrailends
end

def get_neighbours(matrix, coordinate)
  neighbours = []
  i, j = coordinate
  neighbours << [i - 1, j] if i > 0
  neighbours << [i + 1, j] if i < matrix.length - 1
  neighbours << [i, j - 1] if j > 0
  neighbours << [i, j + 1] if j < matrix[0].length - 1
  neighbours
end

#PART 2

def number_of_ways_to_all_trailends_for_coordinate(matrix, coordinate)
  if matrix[coordinate[0]][coordinate[1]] == 9 then return 1 end
  neighbours = get_neighbours(matrix, coordinate)
  ways = 0
  value = matrix[coordinate[0]][coordinate[1]]
  neighbours.each do |neighbour|
    ways += number_of_ways_to_all_trailends_for_coordinate(matrix, neighbour) if matrix[neighbour[0]][neighbour[1]] == value + 1
  end
  ways
end



main
