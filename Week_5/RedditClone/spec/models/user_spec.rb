require 'spec_helper'

describe User do

  it "should have a valid factory" do
    expect(FactoryGirl.create(:user)).to be_valid
  end

  it "should have a username" do
    expect(FactoryGirl.build(:user, :username => nil)).not_to be_valid
  end

  it "should have a password digest" do
    expect(FactoryGirl.build(:user, :password => nil)).not_to be_valid
  end

  it "should not be able to mass assign password digest" do
    expect(FactoryGirl.build(:user)).not_to allow_mass_assignment_of(:password_digest)
  end

  let (:user) { FactoryGirl.create(:user) }

  it "should not store the password in the database" do
    expect(User.find(user.id).password).to be_nil
  end

  it "should have a session token" do
    user.reset_session_token!
    expect(user.session_token).not_to be_nil
  end

  it "should be able to find by credentials" do
    u = FactoryGirl.create(:user, :username => "JenniferUserton", :password => "userpassword")
    expect(User.find_by_credentials("JenniferUserton", "userpassword")).to eq(u)
  end

  it "should has_many moderated subs" do
    expect(have_many :moderated_subs)
   end

end
