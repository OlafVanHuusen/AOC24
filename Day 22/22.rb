require 'aoc_utils'

def main
  numbers = AocUtils.read_ints('Day 22/input.txt')
  buyer_numbers = create_full_buyer_numbers(numbers)
  prices = calculate_prices_from_numbers(buyer_numbers)
  changes = get_changes(prices)
  prices.map! { |price_list| price_list[1..-1] }
  hashmap = create_hashmap(changes, prices)
  puts hashmap.values.max
  puts hashmap.sort_by { |_, v| v }.first(100).to_h
end

def create_hashmap(changes, prices)
  mega_hashmap = Hash.new
  changes.each_with_index do |change_list, i|
    mini_hash = create_hashmap_single_buyer(change_list, prices[i])
    mega_hashmap.merge!(mini_hash) { |key, oldval, newval| oldval + newval }
  end
  mega_hashmap
end

def create_hashmap_single_buyer(changes, prices)
  hashmap = Hash.new
  0.upto(changes.length - 4) do |i|
    change_sequence = changes[i..i + 3]
    price = prices[i + 3]
    unless hashmap.key?(change_sequence)
      hashmap[change_sequence] = price
    end
  end
  hashmap
end

def get_changes(prices)
  changes = Array.new(prices.length) { [] }
  prices.each_with_index do |price_list, i|
    price_list.each_with_index do |price, index|
      if index < price_list.length - 1
        changes[i].append(price_list[index + 1] - price)
      end
    end
  end
  changes
end

def calculate_prices_from_numbers(prices)
  prices.each do |price_list|
    price_list.map! { |price| price % 10 }
  end
  prices
end

def create_full_buyer_numbers(prices)
  2000.times do
    prices.each do |price_list|
      price_list.append(calculate_next_number(price_list[-1]))
    end
  end
  prices
end

def part1(numbers)
  2000.times do
    numbers.map! { |number| calculate_next_number(number) }
  end
  numbers.reduce(:+)
end

def calculate_next_number(number)
  step1 = number * 64
  number = step1 ^ number
  number = number % 16777216
  step2 = (number / 32).floor
  number = step2 ^ number
  number = number % 16777216
  step3 = number * 2048
  number = step3 ^ number
  number % 16777216
end

main