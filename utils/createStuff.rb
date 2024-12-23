def main
  target_directory = '.'
  create_all_directories_and_files(target_directory)
end

def create_all_directories_and_files(directory)
  days = (1..25).to_a
  days.each do |day|
    Dir.mkdir("Day #{day}") unless File.exist?("Day #{day}")
    File.new("Day #{day}/input.txt", "w") unless File.exist?("Day #{day}/input.txt")
    File.write("Day #{day}/#{day}.rb", "require 'aoc_utils'\n\n\ndef main\n\n\nend\n\n\nmain") unless File.exist?("Day #{day}/#{day}.rb")
    File.new("Day #{day}/testinput.txt", "w") unless File.exist?("Day #{day}/testinput.txt")
  end
end

main