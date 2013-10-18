require 'spec_helper'

describe Comment do
  let(:user) { FactoryGirl.create(:user) }
  let(:link) { FactoryGirl.create(:link) }
  let(:comment) { FactoryGirl.create(:comment) }
  let(:child_comment) { FactoryGirl.create(:child_comment) }

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

  it "can have a parent" do
    expect(child_comment.parent).to be_instance_of(Comment)
  end

  it "can have children" do

    parent_comment = FactoryGirl.create(:comment)
    child_comment1 = FactoryGirl.create(
      :child_comment, :parent_id => parent_comment.id
    )
    child_comment2 = FactoryGirl.create(
      :child_comment, :parent_id => parent_comment.id
    )
    child_ids = [child_comment1.id, child_comment2.id]
    comment.children.each do |child|
      expect(child).to be_instance_of(Comment)
      expect(child_ids).to include(child.id)
    end
  end

end
