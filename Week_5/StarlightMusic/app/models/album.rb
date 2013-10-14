class Album < ActiveRecord::Base
  attr_accessible :artist_id, :title

  belongs_to :artist
  has_many :tracks

end
