require 'BigDecimal'

def main
  matrix = parse_input('Day 13/input.txt')
  puts calculateMinimalTokensPaid(matrix)

  #PART 2
  matrix.each do |machine|
    machine[2].map! { |cord| cord + 10000000000000}
  end

  puts calculateMinimalTokensPaid(matrix)
end

def calculateMinimalTokensPaid(matrix)
  total = 0
  matrix.each do |machine|
    total += findBestSolutions(machine[0][0], machine[0][1], machine[1][0], machine[1][1], machine[2][0], machine[2][1])
  end
  total
end

def findBestSolutions(ax, ay, bx, by, px, py)
  ca = (BigDecimal(bx) * BigDecimal(py) - BigDecimal(by) * BigDecimal(px)) / (BigDecimal(bx) * BigDecimal(ay) - BigDecimal(by) * BigDecimal(ax))
  cb = (BigDecimal(px) - BigDecimal(ax) * ca) / BigDecimal(bx)
  if ca.frac.zero? && cb.frac.zero?
    (ca * 3 + cb).to_i
  else
    0
  end
end

def parse_input(file_path)
  input = File.read(file_path).split("\n")
  parsed_data = []

  input.each_slice(4) do |slice|
    button_a = slice[0].match(/Button A: X\+(\d+), Y\+(\d+)/)
    button_b = slice[1].match(/Button B: X\+(\d+), Y\+(\d+)/)
    prize = slice[2].match(/Prize: X=(\d+), Y=(\d+)/)
    parsed_data << [
      [button_a[1].to_i, button_a[2].to_i],
      [button_b[1].to_i, button_b[2].to_i],
      [prize[1].to_i, prize[2].to_i]
    ]
  end
  parsed_data
end

main
