class Friendship < ActiveRecord::Base
  attr_accessible :in_friend_id, :out_friend_id
  validates :in_friend_id, uniqueness: {:scope => :out_friend_id}

  def self.can_friend?(in_friend_id, out_friend_id)
    ourself = in_friend_id == out_friend_id;
    exists = Friendship.exists?({:in_friend_id => in_friend_id,
                          :out_friend_id => out_friend_id })

    return false if (ourself or exists)
    true
  end

end
