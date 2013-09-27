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
    sample_deck.draw_five.count.should == 5
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
    new_hand = Hand.new(sample_deck.draw_five)
    new_hand.cards.count == 5
  end

  it "should compare hands appropriately" do
    (0...test_hands.length - 1).each do |i|
      p test_hands[i+1]
      p test_hands[i].cards
      test_hands[i+1].defeats?(test_hands[i]).should == true
    end
  end

end

describe "Player" do

  subject(:player) { Player.new }

  it "should be able to discard" do
    player.discard.class.should == Card
  end

  it "should respond to prompt (to fold, see, or raise)" do
    player.should respond_to(:prompt)
  end

end

describe "Game" do

  subject(:game) { PokerGame.new }

  it "should have a deck" do
    game.deck.class.should == Deck
  end

  it "should know whose turn it is" do
    game.should respond_to(:turn)
  end

  it "should be able to report how much is in the pot" do
    game.pot.class.should == Fixnum
  end

end
