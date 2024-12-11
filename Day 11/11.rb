def main
  inputArr = File.readlines('Day 11/input.txt')[0].split(' ').map { |input| input.to_i }
  test = [125, 17]
  memory = Hash.new
  fillUpMemory(memory)
  puts "Number of ways to reach the end: " + calculateBlinkRecursive(inputArr, 75, memory).to_s
end

def fillUpMemory(memory)
  for i in 0..10
    for j in 0..25
      calculateBlinkRecursive([i], j, memory)
    end
  end
end

def calculateBlinkRecursive(array, stepsToGo, memory)
  if stepsToGo == 0
    return array.length
  end
  sum = 0
  for i in 0..array.length - 1
    unless memory.has_key?([array[i], stepsToGo])
      memory[[array[i], stepsToGo]] = calculateBlinkRecursive(calculateBlink(array[i]), stepsToGo - 1, memory)
    end
    sum += memory[[array[i], stepsToGo]]
  end
  sum
end

def calculateBlink(n)
  return [1] if n == 0
  if n.to_s.length % 2 == 0
    return [n.to_s[0, n.to_s.length/2].to_i, n.to_s[n.to_s.length/2, n.to_s.length].to_i]
  else
    return [n * 2024]
  end
end

main
