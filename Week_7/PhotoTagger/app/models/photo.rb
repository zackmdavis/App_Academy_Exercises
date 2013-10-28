class Photo < ActiveRecord::Base
  attr_accessible :owner_id, :title, :url
end
