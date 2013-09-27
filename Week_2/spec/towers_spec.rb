require 'rspec'
require 'towers.rb'

describe "HanoiGame" do

  subject(:towers_game) { HanoiGame.new }

  it "lets us view discs on pegs" do
    towers_game.pegs.should == [[3,2,1], [], []]
  end

  it "lets us move a disc" do
    towers_game.move(0, 1)
    towers_game.pegs.should == [[3,2],[1],[]]
  end

  it "does not let us place a larger disc on a smaller disc" do
    towers_game.move(0, 1)
    expect { towers_game.move(0, 1) }.to raise_error(RuntimeError)
  end

  it "does not let us move from an empty peg" do
    expect { towers_game.move(2, 1) }.to raise_error(RuntimeError)
  end

  it "lets us win" do
    towers_game.move(0, 2)
    towers_game.move(0, 1)
    towers_game.move(2, 1)
    towers_game.move(0, 2)
    towers_game.move(1, 0)
    towers_game.move(1, 2)
    towers_game.move(0, 2)
    towers_game.win?.should == true
  end


end