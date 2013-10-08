class Status < ActiveRecord::Base
  attr_accessible :body, :twitter_status_id, :twitter_user_id

  validates :body, :presence => true
  validates :twitter_user_id, :presence => true
  validates :twitter_status_id, :presence => true, :uniqueness => true
end
