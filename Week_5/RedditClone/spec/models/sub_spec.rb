require 'spec_helper'

describe Sub do
  it "should have a valid factory" do
    expect(FactoryGirl.build(:sub)).to be_valid
  end

  it "should have a name" do
    expect(FactoryGirl.build(:sub, :name => nil)).not_to be_valid
  end

  it "should have a moderator" do
    u = FactoryGirl.create(:user)
    expect(FactoryGirl.build(:sub, :mod_id => u.id).moderator).to eq(u)
  end



end
