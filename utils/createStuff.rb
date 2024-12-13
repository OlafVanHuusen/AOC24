def main
  targetDirectory = '.'
  createAllDirectoriesAndFiles(targetDirectory)
end

def createAllDirectoriesAndFiles(directory)
  missingDays = (2..9).to_a + (14..25).to_a
  missingDays.each do |day|
    Dir.mkdir("Day #{day}") unless File.exist?("Day #{day}")
    File.new("Day #{day}/input.txt", "w") unless File.exist?("Day #{day}/input.txt")
    File.new("Day #{day}/#{day}.rb", "w") unless File.exist?("Day #{day}/#{day}.rb")
    File.new("Day #{day}/testinput.txt", "w") unless File.exist?("Day #{day}/testinput.txt")
  end
end

main