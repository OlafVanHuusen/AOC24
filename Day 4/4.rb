def main
  matrix = File.readlines('Day 4/input.txt').map { |row| row.chomp.chars }
  puts search_all_xmas(matrix)
  puts seach_all_xmas2(matrix)
end

def seach_all_xmas2(matrix)
  count = 0
  matrix.each_with_index do |row, index1|
    row.each_with_index do |cell, index2|
      if cell == 'A'
        slash, backslash = false, false
        if search_word(matrix, 'M', 'NE', index1, index2)
          if search_word(matrix, 'S', 'SW', index1, index2)
            slash = true
          end
        end
        if search_word(matrix, 'S', 'NE', index1, index2)
          if search_word(matrix, 'M', 'SW', index1, index2)
            slash = true
          end
        end
        if search_word(matrix, 'M', 'SE', index1, index2)
          if search_word(matrix, 'S', 'NW', index1, index2)
            backslash = true
          end
        end
        if search_word(matrix, 'S', 'SE', index1, index2)
          if search_word(matrix, 'M', 'NW', index1, index2)
            backslash = true
          end
        end
        count += 1 if slash && backslash
      end
    end
  end
  count
end

def search_all_xmas(matrix)
  count = 0
  matrix.each_with_index do |row, index1|
    row.each_with_index do |cell, index2|
      if cell == 'X'
        count += search_word(matrix, 'MAS', 'N', index1, index2) ? 1 : 0
        count += search_word(matrix, 'MAS', 'E', index1, index2) ? 1 : 0
        count += search_word(matrix, 'MAS', 'S', index1, index2) ? 1 : 0
        count += search_word(matrix, 'MAS', 'W', index1, index2) ? 1 : 0
        count += search_word(matrix, 'MAS', 'NE', index1, index2) ? 1 : 0
        count += search_word(matrix, 'MAS', 'SE', index1, index2) ? 1 : 0
        count += search_word(matrix, 'MAS', 'SW', index1, index2) ? 1 : 0
        count += search_word(matrix, 'MAS', 'NW', index1, index2) ? 1 : 0
      end
    end
  end
  count
end

def search_word(matrix, word, direction, indexX, indexY)
  if word.length == 0
    return true
  end
  letter = word[0]
  remainingWord = word[1..-1]
  case direction
  when 'N'
    if indexX - 1 >= 0 && matrix[indexX - 1][indexY] == letter
      search_word(matrix, remainingWord, direction, indexX - 1, indexY)
    end
  when 'E'
    if indexY + 1 < matrix[0].length && matrix[indexX][indexY + 1] == letter
      search_word(matrix, remainingWord, direction, indexX, indexY + 1)
    end
  when 'S'
    if indexX + 1 < matrix.length && matrix[indexX + 1][indexY] == letter
      search_word(matrix, remainingWord, direction, indexX + 1, indexY)
    end
  when 'W'
    if indexY - 1 >= 0 && matrix[indexX][indexY - 1] == letter
      search_word(matrix, remainingWord, direction, indexX, indexY - 1)
    end
  when 'NE'
    if indexX - 1 >= 0 && indexY + 1 < matrix[0].length && matrix[indexX - 1][indexY + 1] == letter
      search_word(matrix, remainingWord, direction, indexX - 1, indexY + 1)
    end
  when 'SE'
    if indexX + 1 < matrix.length && indexY + 1 < matrix[0].length && matrix[indexX + 1][indexY + 1] == letter
      search_word(matrix, remainingWord, direction, indexX + 1, indexY + 1)
    end
  when 'SW'
    if indexX + 1 < matrix.length && indexY - 1 >= 0 && matrix[indexX + 1][indexY - 1] == letter
      search_word(matrix, remainingWord, direction, indexX + 1, indexY - 1)
    end
  when 'NW'
    if indexX - 1 >= 0 && indexY - 1 >= 0 && matrix[indexX - 1][indexY - 1] == letter
      search_word(matrix, remainingWord, direction, indexX - 1, indexY - 1)
    end
  end
rescue NameError
  return false
end

main