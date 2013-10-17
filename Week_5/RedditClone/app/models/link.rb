
class Link < ActiveRecord::Base
  attr_accessible :submitter_id, :sub_id, :title, :url

  validates :title, :presence => true
  validates :url, :presence => true

  belongs_to :submitter, :class_name => "User"
  belongs_to :sub
end
