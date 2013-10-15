class Track < ActiveRecord::Base
  attr_accessible :album_id, :title, :lyrics

  belongs_to :album
  has_one :artist, through: :album
  has_many :notes, :dependent => :destroy

end
