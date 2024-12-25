require 'aoc_utils'

def main
  locks, keys = parse_input(AocUtils.read_chars('Day 25/input.txt'))
  puts part1(locks, keys)
end

def part1(locks, keys)
  matching_pairs = 0
  locks.each do |lock|
    keys.each do |key|
      matching_pairs += 1 if lock_matches_key?(lock, key)
    end
  end
  matching_pairs
end

def lock_matches_key?(lock, key)
  lock.zip(key).map { |a, b| a + b }.max <= 5
end

def parse_input(input)
  locks = []
  keys = []
  input.each_slice(8) do |tuple|
    is_lock = tuple[0][0] == "#"
    if is_lock
      locks << parse_lock(tuple[1..6])
    else
      keys << parse_key(tuple[1..6])
    end
  end
  [locks, keys]
end

def parse_lock(textual_representation)
  lock = Array.new(5) {-1}
  (0..5).each do |row|
    (0..lock.length - 1).each do |column|
      if textual_representation[row][column] == "." && lock[column] == -1
        lock[column] = row
      end
    end
  end
  lock
end

def parse_key(textual_representation)
  key = Array.new(5) {-1}
  (0..5).each do |row|
    (0..key.length - 1).each do |column|
      if textual_representation[row][column] == "#" && key[column] == -1
        key[column] = 5 - row
      end
    end
  end
  key
end

main