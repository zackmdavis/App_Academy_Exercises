def shuffle_lines(file)
  line_array = File.open(file).readlines
  new_file = File.open("#{file}-shuffled.txt", "w")
  line_array.shuffle.each do |line|
    new_file.puts line
  end
end

if __FILE__ == $PROGRAM_NAME
    shuffle_lines(ARGV[0])
end
