class Comment < ActiveRecord::Base
  attr_accessible :body, :link_id, :parent_id, :author_id

  validates :body, :presence => true

  belongs_to :author, :class_name => "User"
  belongs_to :link
  has_many :children, :foreign_key => :parent_id, :class_name => "Comment"
  belongs_to :parent, :foreign_key => :parent_id, :class_name => "Comment"

end
