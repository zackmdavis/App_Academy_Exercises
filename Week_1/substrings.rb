def substrings(str)
  [].tap do |substrings|
    (0...str.length).each do |start|
      (start...str.length).each do |last|
        substrings.push(str[start..last])
      end
    end
  end.uniq
end

def subwords(str)
  valid_words = File.readlines("dictionary.txt").map(&:chomp)
  substrings(str).select{|s| valid_words.include?(s)}
end