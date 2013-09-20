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

  def find_chain(start_word, target_word)
    @new_words = []
    @visited_words = { start_word => nil }
    current_words = [start_word]

    until current_words.empty?
      current_words.each do |current_word|

        new_visited_words = {}
        adjacent_words = adjacent_words(current_word)
        adjacent_words.select! { |adjacent_word| !@visited_words.keys.include?(adjacent_word)}
        @new_words += adjacent_words
        break if @new_words.include?(target_word)
        @new_words.each { |new_word| new_visited_words[new_word] = current_word }
        @visited_words.merge!(new_visited_words)
      end
      current_words = @new_words
      @new_words = []
      p current_words
    end
    @visited_words
  end

  def build_chain(visited_words, target)
    chain = [target]
    parent = visited_words[target]
    until parent.nil?
      chain << parent
      parent = visited_words[parent]
    end
    chain.reverse
  end

  # def find_chain2(start, target)
  #   words = {start => nil}
  #   until words.include?(target) do
  #     more_words = words.map{|k,_| {k => adjacent_words(k)} }
  #     more_words.each do |parent, adj|
  #       unless adj.nil?
  #         adj.each do |new_word|
  #           words.merge({new_word => parent}) unless words.include?(new_word)
  #         end
  #       end
  #     end
  #   end
  #   words
  # end

end

wc = WordChains.new
visited = wc.find_chain("bunt", "mint")
chain = wc.build_chain(visited, "mint")
p chain
#p visited
# my_words = wc.find_chain2("duck", "dust")
# p my_words
# p my_words.select{|k, _| k == "mist"}