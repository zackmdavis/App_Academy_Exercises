class Circle < ActiveRecord::Base
  attr_accessible :name, :user_id

  belongs_to :user
  has_many :circle_memberships
  has_many :circled_friends, :through => :circle_memberships

end
