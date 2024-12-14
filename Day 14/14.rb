def main
  matrix = parse_input('Day 14/input.txt')
  @width = 101
  @height = 103
  #puts part1(matrix)
  puts part2(matrix)
end

def part2(matrix)
  maxRobotsInOneQuadrant = 0
  stepWithMaxRobots = 0
  i = 0
  10000.times do
    i += 1
    calculateStep(matrix)
    quadrants = getQuadrants(matrix)
    quadrants.each do |quadrant|
      if quadrant.length > maxRobotsInOneQuadrant
        maxRobotsInOneQuadrant = quadrant.length
        stepWithMaxRobots = i
      end
    end
  end
  stepWithMaxRobots
end

def printMatrix(matrix)
  0..@width.times do |i|
    0..@height.times do |j|
      if matrix.any? { |robot| robot[0][0] == i && robot[0][1] == j }
        print '#'
      else
        print '.'
      end
    end
    puts
  end
end

def parse_input(file_path)
  input = File.readlines(file_path)
  parsed_data = []
  input.each do |line|
    cords = line.match(/p=(-?\d+),(-?\d+)/).captures.map(&:to_i)
    velocity = line.match(/v=(-?\d+),(-?\d+)/).captures.map(&:to_i)
    parsed_data << [[cords[0], cords[1]], [velocity[0], velocity[1]]]
  end
  parsed_data
end

def part1(matrix)
  100. times do
    calculateStep(matrix)
  end
  calculateSafetyFactor(matrix)
end

def calculateSafetyFactor(matrix)
  quadrants = getQuadrants(matrix)
  factor = 1
  quadrants.each do |quadrant|
    factor *= quadrant.length
  end
  factor
end

def getQuadrants(matrix)
  quadrants = [[], [], [], []]
  matrix.each do |robot|
    if robot[0][0] < (@width - 1) / 2 && robot[0][1] < (@height - 1) / 2
      quadrants[0] << robot
    elsif robot[0][0] > (@width - 1) / 2 && robot[0][1] < (@height - 1) / 2
      quadrants[1] << robot
    elsif robot[0][0] < (@width - 1) / 2 && robot[0][1] > (@height - 1) / 2
      quadrants[2] << robot
    elsif robot[0][0] > (@width - 1) / 2 && robot[0][1] > (@height - 1) / 2
      quadrants[3] << robot
    end
  end
  quadrants
end

def calculateStep(matrix)
  matrix.each do |robot|
    robot[0][0] = (robot[0][0] + robot[1][0]) % @width
    robot[0][1] = (robot[0][1] + robot[1][1]) % @height
  end
end




main