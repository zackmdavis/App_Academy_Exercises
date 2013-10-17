require 'spec_helper'

describe Comment do
  let(:user) { FactoryGirl.create(:user) }
  let(:link) { FactoryGirl.create(:link) }
  let(:comment) { FactoryGirl.create(:comment) }

  it "has a valid factory" do
    expect(comment).to be_valid
  end

  it "validates presence of body" do
    expect(FactoryGirl.build(:comment, :body => nil)).not_to be_valid
  end

  it "belongs to an author" do
    expect(comment.author).to be_instance_of(User)
  end

  it "belongs to a link" do
    expect(comment.link).to be_instance_of(Link)
  end

end
