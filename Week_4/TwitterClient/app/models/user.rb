require 'json'

class User < ActiveRecord::Base
  attr_accessible :screen_name, :twitter_user_id

  validates :screen_name, :presence => true
  validates :twitter_user_id, :presence => true, :uniqueness => true

  has_many :statuses, :class_name => "Status", :primary_key => :twitter_user_id, :foreign_key => :twitter_user_id

  def self.fetch_by_screen_name(screen_name)
    access_token = YAML::load(File.open("lib/saved_token.yaml", 'r'))
    user_raw_json = access_token.get("https://api.twitter.com/1.1/users/lookup.json?screen_name=#{screen_name}").body
    user_data = JSON.parse(user_raw_json).first
    p self.parse_twitter_params(user_data)
  end

  def self.parse_twitter_params(user_data)
    User.create!(:screen_name => user_data["screen_name"], :twitter_user_id => user_data["id"] )
  end

end
