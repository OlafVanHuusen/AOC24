def main
  task2
end

def task1
  input = File.readlines('Day 1/input.txt').map { |line| line.split("   ") }
  listOne, listTwo = [], []
  input.each do |line| listOne << line[0].to_i; listTwo << line[1].to_i end
  listOne.sort!; listTwo.sort!
  sum = 0
  for i in 0..listOne.length - 1
    sum += (listOne[i] - listTwo[i]).abs
  end
  puts sum
end

def task2
  input = File.readlines('Day 1/input.txt').map { |line| line.split("   ") }
  listOne, listTwo = [], []
  input.each do |line| listOne << line[0].to_i; listTwo << line[1].to_i end
  listOneHash, listTwoHash = Hash.new(0), Hash.new(0)
  listOne.each do |number| listOneHash[number] += 1 end
  listTwo.each do |number| listTwoHash[number] += 1 end
  sum = 0
  listOneHash.each do |key, value|
    if listTwoHash.has_key?(key) then sum += key * value * listTwoHash[key] end
  end
  puts sum
end

main

