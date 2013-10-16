class CircleMembership < ActiveRecord::Base
  attr_accessible :circle_id, :circled_id

  belongs_to :circled_friend, :class_name => "User", :foreign_key => :circled_id
  belongs_to :circle

end
