class PokerGame

  attr_accessor :turn, :pot, :current_bet

  NUMBER_OF_PLAYERS = 3
  DEFAULT_NAMES = ["Twilight Sparkle", "Rainbow Dash", "Larry"]

  def initialize
    @turn = 0
    @pot = 0
    @current_bet = 1
    @deck = Deck.new
    @players = []
    NUMBER_OF_PLAYERS.times do |i|
      @players.push(Player.new(DEFAULT_NAMES[i], @deck))
    end
  end

  def play
    betting_round
    discard_round
    betting_round
    determine_winner
  end

  def betting_round
    still_playing = @players.reject { |player| player.folded }
    still_playing.each do |player|
      action = player.prompt(@current_bet)
      if action
        @pot += action
        if action > @current_bet
          @current_bet = action
        end
      end
    end
  end

  def discard_round
    still_playing = @players.reject { |player| player.folded }
    still_playing.each do |player|
      player.select_discards
    end
  end

  def determine_winner
    still_playing = @players.reject { |player| player.folded }
    until still_playing.count == 1
      if still_playing[0].hand.defeats?(still_playing[1].hand)
        still_playing.delete_at(1)
      else
        still_playing.delete_at(0)
      end
    end
    winnner = still_playing[0]
    puts "#{winner.name} is the winner!! everyone else is destroyed"
    return winner
  end

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


  def rank_counts
    counts = Hash.new(0)
    @cards.each do |card|
      counts[card.rank] += 1
    end
    counts
  end

  def one_pair
    if rank_counts.values.max == 2
      rank_of_pair = rank_counts.key(2)
      other_ranks = @cards.map{ |card| card.rank }.reject { |r| r == rank_of_pair }.sort.reverse
      return [rank_of_pair] + other_ranks
    else
      return false
    end
  end

  def two_pair
    if rank_counts.values.sort[-2..-1] == [2, 2]
      ranks_of_pairs = rank_counts.select{ |rank, count| count == 2 }.map{ |rank, _| rank }.sort.reverse
      other_rank = rank_counts.keys.reject{ |rank| ranks_of_pairs.include?(rank) }
      return ranks_of_pairs + other_rank
    else
      return false
    end
  end

  def three_of_kind
    rank_counts.values.max == 3
  end

  def straight
    sorted_cards = cards.sort { |card1, card2| card1.rank <=> card2.rank }
    (0..3).each do |i|
      if sorted_cards[i+1].rank - sorted_cards[i].rank != 1
        return false
      end
    end
    return true
  end

  def flush
    first_suit = @cards[0].suit
    @cards.all? { |card| card.suit == first_suit }
  end

  def full_house
    rank_counts.values.sort == [2, 3]
  end

  def four_of_kind
    rank_counts.values.max == 4
  end

  def straight_flush
    flush and straight
  end

  def score
    if straight_flush
      return [10, straight_flush]
    elsif four_of_kind
      return [9, four_of_kind]
    elsif full_house
      return [8, full_house]
    elsif flush
      return [7, flush]
    elsif straight
      return [6, straight]
    elsif three_of_kind
      return [5, three_of_kind]
    elsif two_pair
      return [4, two_pair]
    elsif one_pair
      return [3, one_pair]
    else
      return [2, @cards.map{ |card| card.rank }.sort.reverse]
    end
  end

  def defeats?(other_hand)
    my_score = score
    their_score = other_hand.score
    if my_score[0] > their_score[0]
      return true
    elsif my_score[0] < their_score[0]
      return false
    else
      (0...my_score[1].length).each do |i|
        if my_score[1][i] > their_score[1][i]
          return true
        elsif my_score[1][i] < their_score[1][i]
          return false
        end
      end
      raise "Miraculous tie!!"
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

  def draw_n(n)
    drawn = []
    n.times do
      drawn.push(draw)
    end
    drawn
  end

  def size
    @cards.length
  end
end


class Player

  attr_accessor :name, :hand, :folded, :bet, :raised

  def initialize(name, deck)
    @name = name
    @money = 500
    @deck = deck
    @hand = Hand.new(@deck.draw_n(5))
    @folded = false
    @bet = 0
    @raised = false
  end

  def select_discards
    max_number_to_discard = rand(0..3)
    to_discard = []
    max_number_to_discard.times do
      discard_index = rand(0..4)
      to_discard.push(@hand.cards[discard_index])
    end
    to_discard.uniq
  end

  def discard(discards)
    cards = @hand.cards
    cards = cards.reject{ |card| discards.include?(card) }
    need_to_draw = 5 - cards.count
    cards.push(@deck.draw_n(need_to_draw))
    cards.flatten!
    @hand = Hand.new(cards)
  end

  # player randomly folds, sees, or raises
  def prompt(current_bet)
    action = [false, current_bet, current_bet+7].sample
    if !action
      @folded = true
    elsif action == current_bet
      @bet = action
    elsif action > current_bet
      @bet = action
      raised = true
    end
    action
  end

end
