require 'pycall/import'
include PyCall::Import

def main
  matrix = parse_input('Day 13/testinput.txt')
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
    total += calculateMinimalTokensPaidMachine(machine)
  end
  total
end

def calculateMinimalTokensPaidMachine(machine)
  button_a = machine[0]
  button_b = machine[1]
  prize = machine[2]
  x1 = button_a[0]
  y1 = button_a[1]
  x2 = button_b[0]
  y2 = button_b[1]
  z1 = prize[0]
  z2 = prize[1]
  solution = findBestSolutions(x1, y1, x2, y2, z1, z2)
end

def findAllSolutions(x1, y1, x2, y2, z1, z2)
  solutions = []
  # Find all solutions for the equation system x1a + x2b = z1 ; y1a + y2b = z2
  solutions = findSolutionsDiophantine(x1, y1, x2, y2, z1, z2)
  solutions
end

def findBestSolutions(x1, y1, x2, y2, z1, z2)
  pyexec <<-PYTHON
    from tqdm import tqdm
    from ortools.linear_solver import pywraplp
    def calc():
      with open("C://Users//lclic//RubymineProjects//AOC24//Day 13//input.txt", "r") as file:
          game = [g.splitlines() for g in file.read().split("\n\n") if g]
      part2 = 1
      total, big = 0, 1e13
      for g in tqdm(game):
          xa, ya = map(lambda x: int(x.split("+")[1]), g[0].split(", "))
          xb, yb = map(lambda x: int(x.split("+")[1]), g[1].split(", "))
          gx, gy = map(lambda x: int(x.split("=")[1]), g[2].split(", "))
          solver = pywraplp.Solver.CreateSolver('SCIP')
          if not solver:
              print('Solver not created!')
              exit()
          a, b = solver.IntVar(0.0, solver.infinity(), 'a'), solver.IntVar(0.0, solver.infinity(), 'b')
          solver.Minimize(3 * a + b)
          solver.Add(a * xa + b * xb == gx + part2 * big)
          solver.Add(a * ya + b * yb == gy + part2 * big)
          if solver.Solve() == pywraplp.Solver.OPTIMAL:
              total += solver.Objective().Value()

      print(total)
    if __name__ == '__main__':
      calc()
    PYTHON

  solve_diophantine = PyCall.import_module('__main__').method(:solve_diophantine)
  solve_diophantine.(x1, y1, x2, y2, z1, z2)
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
