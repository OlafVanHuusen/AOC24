require 'aoc_utils'

def main
  disk_map = AocUtils.read_chars('Day 9/input.txt').flatten
  storage = disk_map_to_storage(disk_map)
  #part1(storage)
  part2(storage)
end

def part1(storage)
  clean_storage(storage)
  puts calculate_checksum(storage)
end

def part2(storage)
  clean_up_v2(storage)
  puts calculate_checksum(storage)
end

def clean_up_v2(storage)

end

def calculate_checksum(storage)
  checksum = 0
  storage.each_with_index do |char, index|
    if char == "."
      next
    end
    checksum += index * storage[index].to_i
  end
  checksum
end

def clean_storage(storage)
  last_digit = storage.rindex { |char| char.match?(/[0-9]/) }
  first_point = storage.index(".")
  while first_point < last_digit
    puts first_point
    temp = storage[first_point]
    storage[first_point] = storage[last_digit]
    storage[last_digit] = temp
    last_digit = storage.rindex { |char| char.match?(/[0-9]/) }
    first_point = storage.index(".")
  end
end

def disk_map_to_storage(disk_map)
  storage = []
  id_number = 0
  disk_map.each_slice(2) do |full_bytes, empty|
    full_bytes.to_i.times do |i|
      storage << id_number.to_s
    end
    empty.to_i.times do |i|
      storage << "."
    end
    id_number += 1
  end
  storage
end

main