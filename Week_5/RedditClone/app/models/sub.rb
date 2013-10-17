class Sub < ActiveRecord::Base
  attr_accessible :mod_id, :name
  validates :name, :presence => true

  belongs_to :moderator, :foreign_key => :mod_id, :class_name => "User"
end
