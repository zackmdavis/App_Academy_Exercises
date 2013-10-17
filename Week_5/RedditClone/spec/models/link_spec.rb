require 'spec_helper'

describe Link do

  let(:user) { FactoryGirl.create(:user) }
  let(:link) { FactoryGirl.create(:link) }

  it "has a valid factory" do
    expect(link).to be_valid
  end

  it "validates presence of title" do
    expect(FactoryGirl.build(:link, :title => nil)).not_to be_valid
  end

  it "validates presence of url" do
    expect(FactoryGirl.build(:link, :url => nil)).not_to be_valid
  end

  it "has a submitter" do
    expect(link.submitter).to be_instance_of(User)
  end

end
