class Paste < ActiveRecord::Base
  attr_accessible :body, :owner_id, :title

  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id
  has_many :favorites
end
