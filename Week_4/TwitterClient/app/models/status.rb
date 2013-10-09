require 'json'

class Status < ActiveRecord::Base
  attr_accessible :body, :twitter_status_id, :twitter_user_id

  validates :body, :presence => true
  validates :twitter_user_id, :presence => true
  validates :twitter_status_id, :presence => true, :uniqueness => true

  belongs_to :user, :class_name => "User", :primary_key => :twitter_user_id, :foreign_key => :twitter_user_id

  def self.fetch_statuses_for_user(user)
    access_token = YAML::load(File.open("lib/saved_token.yaml", 'r'))
    if !user.statuses.empty?
      most_recent_id = self.get_most_recent_status(user).twitter_status_id
      p most_recent_id
      url = "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=#{user.twitter_user_id}&since_id=#{most_recent_id}"
      statuses_raw_json = access_token.get(url).body
      status_hashes = JSON.parse(statuses_raw_json)
      status_hashes.each do |status_hash|
        truncated_status_hash = {:body => status_hash["text"], :twitter_status_id => status_hash["id"], :twitter_user_id => user.twitter_user_id }
        Status.create!(truncated_status_hash)
      end
    else
      url = "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=#{user.twitter_user_id}&count=9"
      statuses_raw_json = access_token.get(url).body
      status_hashes = JSON.parse(statuses_raw_json)
      status_hashes.each do |status_hash|
        truncated_status_hash = {:body => status_hash["text"], :twitter_status_id => status_hash["id"], :twitter_user_id => user.twitter_user_id }
        Status.create!(truncated_status_hash)
      end
    end
  end

  def self.get_most_recent_status(user)
    user.statuses.all.max_by { |status| status.twitter_status_id }
  end
end
