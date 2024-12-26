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
  storage = to_smaller_storage(storage)
  storage = clean_up_v2(storage)
  storage = to_bigger_storage(storage)
  puts calculate_checksum(storage)
end

def clean_up_v2(small_storage)
  free_storage = get_free_storage(small_storage)
  queue = []
  (0...small_storage.length).reverse_each do |i|
    if small_storage[i][0] == "."
      next
    end
    free_storage.each_with_index do |free_storage_element, free_storage_index|
      if free_storage_element[0] >= i
        break
      end
      if free_storage_element[1] >= small_storage[i][1]
        queue << [free_storage_element[0], small_storage[i][0], small_storage[i][1]]
        small_storage[i][0] = "."
        free_storage[free_storage_index][1] -= small_storage[i][1]
        break
      end
    end
  end
  queue_indices = queue.map { |index, value, count| index }.uniq
  free_storage.each do |index, count|
    if count > 0 && queue_indices.include?(index)
      queue << [index, ".", count]
    end
  end
  queue.sort_by! { |index, value, count| index }
  new_storage = []
  (0...small_storage.length).each do |i|
    if queue_indices.include?(i)
      while queue.length > 0 && queue[0][0] == i
        new_storage << queue.shift[1..2]
      end
    else
      new_storage << small_storage[i]
    end
  end
  new_storage
end

def get_free_storage(small_storage)
  free_storage = []
  small_storage.each_with_index do |value, index|
    if value[0] == "."
      free_storage << [index, value[1]]
    end
  end
  free_storage
end

def to_smaller_storage(storage)
  new_storage = []
  while storage.length > 0
    current_value = storage.shift
    count = 1
    while storage[0] == current_value
      count += 1
      storage.shift
    end
    new_storage << [current_value, count]
  end
  new_storage
end

def to_bigger_storage(storage)
  new_storage = []
  storage.each do |value, count|
    count.times do
      new_storage << value
    end
  end
  new_storage
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