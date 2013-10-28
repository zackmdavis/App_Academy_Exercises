class PhotoTagging < ActiveRecord::Base
  attr_accessible :photo_id, :user_id, :x_pos, :y_pos
end
