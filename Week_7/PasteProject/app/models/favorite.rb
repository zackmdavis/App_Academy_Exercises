class Favorite < ActiveRecord::Base
  attr_accessible :paste_id, :user_id

  belongs_to :user
  belongs_to :paste
end
