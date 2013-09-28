require 'rspec'
require 'poker.rb'

describe "Card" do

  subject(:test_card) { Card.new(:heart, 8) }

  it "should have a rank" do
    test_card.rank.should == 8
  end

  it "should have a suit" do
    test_card.suit.should == :heart
  end

  it "should pretty print" do
    test_card.pretty_print.should == "8"+"\u2665"
  end

end

describe "Deck" do

  subject(:sample_deck) { Deck.new }

  it "should initialize with 52 cards" do
    sample_deck.size.should == 52
  end

  it "should let us draw cards" do
    sample_deck.draw.class.should == Card
  end

  it "should get smaller after we draw cards" do
    5.times do
      sample_deck.draw
    end
    sample_deck.size.should == 47
  end

  it "should let us draw five cards" do
    sample_deck.draw_n(5).count.should == 5
  end

end

describe "Hand" do

  let(:sample_deck) { Deck.new }

  let(:test_pair) { Hand.new([[:heart, 2],
                      [:club, 2],
                      [:heart, 3],
                      [:heart, 4],
                      [:heart, 5]].map{ |suit, rank| Card.new(suit, rank) }) }
  let(:test_twopair) { Hand.new([[:heart, 2],
                      [:club, 2],
                      [:heart, 4],
                      [:diamond, 4],
                      [:heart, 5]].map{ |suit, rank| Card.new(suit, rank) }) }
  let(:test_twopair2) { Hand.new([[:diamond, 2],
                      [:spade, 2],
                      [:diamond, 4],
                      [:heart, 4],
                      [:heart, 6]].map{ |suit, rank| Card.new(suit, rank) }) }

  let(:test_threekind) { Hand.new([[:heart, 2],
                      [:club, 2],
                      [:heart, 2],
                      [:heart, 4],
                      [:heart, 5]].map{ |suit, rank| Card.new(suit, rank) }) }
  let(:test_straight) { Hand.new([[:heart, 2],
                      [:club, 3],
                      [:heart, 4],
                      [:heart, 5],
                      [:heart, 6]].map{ |suit, rank| Card.new(suit, rank) }) }
  let(:test_flush) { Hand.new([[:heart, 2],
                      [:heart, 3],
                      [:heart, 9],
                      [:heart, 8],
                      [:heart, 5]].map{ |suit, rank| Card.new(suit, rank) }) }
  let(:test_fullhouse) { Hand.new([[:heart, 2],
                      [:diamond, 2],
                      [:diamond, 4],
                      [:club, 4],
                      [:heart, 4]].map{ |suit, rank| Card.new(suit, rank) }) }
  let(:test_fourkind) { Hand.new([[:heart, 2],
                      [:diamond, 2],
                      [:club, 2],
                      [:spade, 2],
                      [:heart, 5]].map{ |suit, rank| Card.new(suit, rank) }) }
  let(:test_straightflush) { Hand.new([[:heart, 2],
                      [:heart, 3],
                      [:heart, 4],
                      [:heart, 5],
                      [:heart, 6]].map{ |suit, rank| Card.new(suit, rank) }) }
  let(:test_hands) { [test_pair, test_twopair, test_threekind, test_straight, test_flush,
                      test_fullhouse, test_fourkind, test_straightflush] }


  it "should initialize from deck with five cards" do
    new_hand = Hand.new(sample_deck.draw_n(5))
    new_hand.cards.count == 5
  end

  it "should compare hands appropriately" do
    (0...test_hands.length - 1).each do |i|
      test_hands[i+1].defeats?(test_hands[i]).should == true
    end
  end

  it "should cope with tiebreaking" do
    expect(test_twopair2.defeats?(test_twopair)).to eq(true)
  end

end

describe "Player" do

  subject(:player) { Player.new("Rebecca", Deck.new) }


  it "should be able to discard" do
    to_discard = player.hand.cards[0..1]
    player.discard(to_discard)
    to_discard.each do |discard|
      expect(player.hand.cards.include?(discard)).to be_false
    end
    player.hand.cards.count.should == 5
  end

  it "should respond to prompt (to fold, see, or raise)" do
    player.should respond_to(:prompt)
  end

end

describe "Game" do

  subject(:game) { PokerGame.new }
  let(:player) { Player.new(game.deck) }
  let(:test_win_game) { PokerGame.new }

  it "should know whose turn it is" do
    game.should respond_to(:turn)
  end

  it "should be able to report how much is in the pot" do
    game.pot.class.should == Fixnum
  end

  it "should run a round of betting" do
    game.betting_round
    ((game.current_bet - 1) % 7).should == 0
  end

  it "should play a game" do
    game.play
  end


end
