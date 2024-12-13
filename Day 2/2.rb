def main
  task1
  task2
end

def task1
  puts File.readlines('Day 2/input.txt').map { |numberString|  numberString.split(' ').map { |number| number.to_i} }.reduce(0) { |sum, report| sum + (report.each_cons(2).reduce([true, 0]) { |acc, (a, b)| [acc[0] && ((a - b).abs <= 3) && ((acc[1] == 0 && a != b) || ((acc[1] == 1) ? a < b : b < a)), (a < b ? 1 : 2)] }[0] ? 1 : 0) }
end

def task2
  puts File.readlines('Day 2/input.txt').map { |numberString|  numberString.split(' ').map { |number| number.to_i} }.reduce(0) { |sum, report| sum + ((-1..(report.length - 1)).to_a.reduce(false) { |acc, i| acc || (i == -1 ? report.clone : report.clone.tap { |r| r.delete_at(i) }).each_cons(2).reduce([true, 0]) { |acc2, (a, b)| [acc2[0] && ((a - b).abs <= 3) && (((acc2[1] == 0) && (a != b)) || ((acc2[1] == 1) ? a < b : b < a)), (a < b ? 1 : 2)] }[0]} ? 1 : 0) }
end

main