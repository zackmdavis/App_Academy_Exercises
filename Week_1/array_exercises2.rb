class HanoiGame

  def self.play(num_discs)

    discs = [(1..num_discs).to_a.reverse,[],[]]

    until discs[2] == (1..num_discs).to_a.reverse
      print discs, "\n"
      puts "Write the index of the pile you want to move from (pile 1, 2, or 3) and to in the form 'from,to'"
      to_and_from = gets.chomp
      index_from,index_to = to_and_from.split(",").map{|char| char.to_i-1}
      if discs[index_from].empty?
        puts "Cannot move from an empty pile!"
        next
      end
      if not discs[index_to].empty?
        if (discs[index_from][-1] > discs[index_to][-1])
          puts "You can't put a larger disc on a smaller one, dummy"
          next
        end
      end
      discs[index_to].push(discs[index_from].pop)
    end
    puts "You win!"
  end

end

HanoiGame.play(3)