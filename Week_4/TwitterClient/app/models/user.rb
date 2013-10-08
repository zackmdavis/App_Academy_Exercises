class User < ActiveRecord::Base
  attr_accessible :screen_name, :twitter_user_id

  validates :screen_name, :presence => true
  validates :twitter_user_id, :presence => true, :uniqueness => true

  def self.fetch_by_screen_name

  end

end
