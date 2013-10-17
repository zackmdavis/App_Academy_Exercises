require 'spec_helper'

describe Link do
  it "should have a valid factory" do
    expect(FactoryGirl.build(:sub)).to be_valid
  end

  it "should have a submitter" do
    u = FactoryGirl.create(:user)
    expect(FactoryGirl.build())
  end

end
