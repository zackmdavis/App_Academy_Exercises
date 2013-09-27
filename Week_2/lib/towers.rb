class HanoiGame

  attr_accessor :pegs

  def initialize
    @pegs = [[3,2,1], [], []]
  end

  def move(from, to)
    if @pegs[from].empty?
      raise "can't move from an empty peg!!"
    end
    if !@pegs[to].empty?
      if @pegs[from].last > @pegs[to].last
        raise "can't put a larger disc on a smaller one!!"
      end
    end
    @pegs[to].push(@pegs[from].pop)
  end

  def win?
    @pegs == [[], [], [3,2,1]]
  end

end