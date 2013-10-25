class Friendship < ActiveRecord::Base
  attr_accessible :in_friend_id, :out_friend_id
  validates :in_friend_id, uniqueness: {:scope => :out_friend_id}
end
