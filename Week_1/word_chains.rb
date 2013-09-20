class String
  def adjacent?(word)
    return false unless self.length == word.length
    matches = 0
    word.length.times do |i|
      matches += 1 if self[i] == word[i]
    end
    (word.length - matches) == 1 ? true : false
  end
end

class WordChains

  DICTIONARY = File.readlines('dictionary.txt').map(&:chomp)

  def adjacent_words(word)
    DICTIONARY.select { |other_word| other_word.adjacent?(word) }
  end

  def find_chain(start, target)
    found = false
    scanned = []
    to_scan = []
    to_scan.push({start => nil})
    while !to_scan.empty? and !found do
      scanning = to_scan.shift
      if scanning.keys[0] == target
        found = true
        scanned.push(scanning)
      else
        adjacent_words(scanning.keys[0]).each do |adj_word|
           if !scanned.include?(adj_word) and !to_scan.include?(adj_word)
             to_scan.push({adj_word => scanning.keys[0]})
           end
        end
        scanned.push(scanning)
      end
    end
    found ? construct_path(target, scanned) : nil
  end 

  private

  def construct_path(target, scanned)
    chain = [target]
    backlink = scanned.find{|h| h.keys[0] == target}
    parent = backlink[target]
    until parent.nil?
      chain.push(parent)
      backlink = scanned.find{|h| h.keys[0] == parent}
      parent = backlink[parent]
    end
    chain.reverse
  end

end

wc = WordChains.new
path = wc.find_chain("bunt", "mint")
p path
