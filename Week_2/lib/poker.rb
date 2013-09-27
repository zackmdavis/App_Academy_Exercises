class PokerGame

end

class Card

  attr_accessor :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def pretty_print
    faces = {11 => 'J', 12 => 'Q', 13 => 'K', 14 => 'A'}
    display_suits = {:heart => "\u2665", :diamond => "\u2666", :spade => "\u2660", :club => "\u2663"}
    if @rank >= 11
      display_rank = faces[@rank]
    else
      display_rank = String(@rank)
    end
    display_suit = display_suits[@suit]
    display_rank + display_suit
  end

end

class Hand

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def pretty_print
    @cards.each do |card|
      print card.pretty_print, " "
    end
    puts
  end

  def most_of_same_rank
    most = 1
    @cards.each do | special_card |
      special_count = @cards.select { |card| card.rank == special_card.rank }.count
      if special_count > most
        most = special_count
      end
    end
    most
  end

  def rank_counts
    counts = Hash.new(0)
    @cards.each do |card|
      counts[card.rank] += 1
    end
    counts
  end

  def one_pair?
    most_of_same_rank == 2
  end

  def two_pair?
    pair_ranks = []
    @cards.each do |card|
      if @cards.select { |other_card| other_card.rank == card.rank }.count == 2
        pair_ranks.push(card.rank) unless pair_ranks.include?(card.rank)
      end
    end
    puts pair_ranks
    pair_ranks.count == 2
  end

  def three_of_kind?
    most_of_same_rank == 3
  end

  def straight?
    sorted_cards = cards.sort(&:rank)
    (0..3).each do |i|
      if sorted_cards[i+1].rank - sorted_cards[i].rank != 1
        return false
      end
    end
    return true
  end

  def flush?
    first_suit = @cards[0].suit
    @cards.all? { |card| card.suit == first_suit }
  end

  def full_house?
    rank_counts.values.sort == [2, 3]
  end

  def four_of_kind?
    most_of_same_rank == 4
  end

  def straight_flush?

    flush? and straight?
  end

  def defeats?(other_hand)
    hand_outcomes = [ Proc.new{ |hand| hand.straight_flush? },
      Proc.new{ |hand| hand.four_of_kind? },
      Proc.new{ |hand| hand.full_house? },
      Proc.new{ |hand| hand.flush? },
      Proc.new{ |hand| hand.straight? },
      Proc.new{ |hand| hand.three_of_kind? },
      Proc.new{ |hand| hand.two_pair? },
      Proc.new{ |hand| hand.one_pair? }]
    hand_outcomes.each do |outcome|
      if outcome.call(other_hand) and !outcome.call(self)
        return false
      elsif !outcome.call(other_hand) and outcome.call(self)
        return true
      else
        raise "We didn't implement tiebreaking yet!!"
      end
    end
  end

end

class Deck

  def initialize
    suits = [[:heart]*13, [:diamond]*13, [:club]*13, [:spade]*13].flatten
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]*4
    @cards = suits.zip(ranks).map { |suit, rank| Card.new(suit, rank) }
    @cards.shuffle
  end

  def draw
    @cards.pop
  end

  def draw_five
    drawn = []
    5.times do
      drawn.push(draw)
    end
    drawn
  end

  def size
    @cards.length
  end
end



class Player
end
