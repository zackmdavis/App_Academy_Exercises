require 'rspec'
require 'questions.rb'

describe "User" do

  let(:user1) { User.find_by_id(1) }
  let(:user2) { User.find_by_id(2) }

  it "should tell us authored questions" do
    # user #1 authored posts #1 and 3 in our starting database
    expect(user1.authored_questions.map{ |question| question.id }).to eq([1,3])
  end

  it "should tell us followed questions" do
    # user #2 followed posts #1 and 2 in our starting database
    expect(user2.followed_questions.map{ |question| question.id}).to eq([1,2])
  end

  it "should tell us liked questions" do
    # &c.
    expect(user2.liked_questions.map{ |question| question.id}).to eq([1,3])
  end

  it "class should let us find users by name" do
    user2.id.should == User.find_by_name("Carl P.", "Userton")[0].id
  end

  it "class should let us find users by id" do
    User.find_by_id(1).first.should == "Jennifer Q."
  end


end


describe "Question" do

  it "should let us find questions by id" do
    Question.find_by_id(1).title.should == "Did you used to wonder what friendship could be?"
  end

end

describe "Reply" do

  it "should let us find replies by id" do
    Reply.find_by_id(2).body.should == "Truly outrageous"
  end

end