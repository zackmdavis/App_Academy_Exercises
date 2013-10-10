class Group < ActiveRecord::Base
  attr_accessible :user_id, :name

  belongs_to :user
  has_many :contacts, :through => :group_memberships, :source => :contacts
end
