def main
  @matrix = File.readlines('Day 12/input.txt').map { |line| line.chars.map{ |char| char }}.each do |row| row.delete("\n") end
  @length = @matrix.length
  @width = @matrix[0].length
  cordsToRegions = Hash.new
  regions = []
  for i in 0..@length-1
    for j in 0..@width-1
      cordsToRegions[[i, j]] = -1
    end
  end
  findRegions(cordsToRegions, regions)
  regionPerimeters = []
  for i in 0..regions.length - 1
    regionPerimeters << calculateRegionPerimeter(regions[i])
  end
  puts regions.map { |region| region.length * regionPerimeters[regions.index(region)] }.reduce(:+)

  #PART 2
  regionsSides = []
  for i in 0..regions.length - 1
    regionsSides << calculateRegionSides(regions[i])
    end
  puts regions.map { |region| region.length * regionsSides[regions.index(region)] }.reduce(:+)
end

def calculateRegionPerimeter(region)
  perimeter = 0
  region.each do |cords|
    neighbors = findNeighbors(cords[0], cords[1])
    neighbors.each do |neighbor|
      unless region.include?(neighbor)
        perimeter += 1
      end
    end
    if isAtCorner(cords)
      perimeter += 2
    elsif isAtEdge(cords)
      perimeter += 1
    end
  end
  perimeter
end

def isAtCorner(cords)
  cords[0] == 0 && cords[1] == 0 || cords[0] == 0 && cords[1] == @width - 1 || cords[0] == @length - 1 && cords[1] == 0 || cords[0] == @length - 1 && cords[1] == @width - 1
end

def isAtEdge(cords)
  cords[0] == 0 || cords[1] == 0 || cords[0] == @length - 1 || cords[1] == @width - 1
end

def findRegions(cordsToRegions, regions)
  for i in 0..@length-1
    for j in 0..@width-1
      if cordsToRegions[[i, j]] == -1
        regionNumber = regions.length
        region = findRegion(regionNumber, i, j, cordsToRegions)
        regions << region
      end
    end
  end
end

def findRegion(regionNumber, i, j, cordsToRegions)
  region = []
  queue = [[i, j]]
  while queue.size > 0
    current = queue.shift
    if region.include?(current) then next end
    region << current
    cordsToRegions[current] = regionNumber
    neighbors = findNeighbors(current[0], current[1])
    neighbors.each do |neighbor|
      if @matrix[neighbor[0]][neighbor[1]] == @matrix[current[0]][current[1]] && cordsToRegions[neighbor] == -1
        queue << neighbor
      end
    end
  end
  region
end

def findNeighbors(i, j)
  neighbors = []
  neighbors << [i - 1, j] if i > 0
  neighbors << [i + 1, j] if i < @length - 1
  neighbors << [i, j - 1] if j > 0
  neighbors << [i, j + 1] if j < @width - 1
  neighbors
end

#PART 2

def calculateRegionSides(region)
  lookOnSides = sidesOnDifferentX(region)
  lookOnSides2 = sidesOnDifferentY(region)
  calculateSides(region, lookOnSides) + calculateSides(region, lookOnSides2)
end

def sidesOnDifferentX(region)
  lookOnSides = Array.new(@length + 2) { [] }
  region.each do |cords|
    if cords[0] == 0
      lookOnSides[@length] << cords
    elsif cords[0] == @length - 1
      lookOnSides[@length + 1] << cords
    end
    neighbors = findNeighbors(cords[0], cords[1])
    neighbors.each do |neighbor|
      unless region.include?(neighbor) || neighbor[0] == cords[0]
        lookOnSides[neighbor[0]] << cords
      end
    end
  end
  lookOnSides
end

def sidesOnDifferentY(region)
  lookOnSides = Array.new(@width + 2) { [] }
  region.each do |cords|
    if cords[1] == 0
      lookOnSides[@width] << cords
    elsif cords[1] == @width - 1
      lookOnSides[@width + 1] << cords
    end
    neighbors = findNeighbors(cords[0], cords[1])
    neighbors.each do |neighbor|
      unless region.include?(neighbor) || neighbor[1] == cords[1]
        lookOnSides[neighbor[1]] << cords
      end
    end
  end
  lookOnSides
end

def calculateSides(region, lookOnSides)
  sides = 0
  for i in 0..lookOnSides.length - 1
    sides += countSides(lookOnSides[i])
  end
  sides
end

def countSides(sides)
  ret = 0
  if sides.length == 0 then return 0 end
  queueOuter = sides.clone
  while queueOuter.size > 0
    side = queueOuter.shift
    queue = [side]
    while queue.size > 0
      current = queue.shift
      if sides.include?(current)
        sides.delete(current)
        queueOuter.delete(current)
        neighbors = findNeighbors(current[0], current[1])
        neighbors.each do |neighbor|
          if sides.include?(neighbor)
            queue << neighbor
          end
        end
      end
    end
    ret += 1
  end
  ret
end

main