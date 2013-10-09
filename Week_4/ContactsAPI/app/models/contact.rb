class Contact < ActiveRecord::Base
  attr_accessible :email, :name, :user_id
  validates :email, :name, :user_id, :presence => true

  belongs_to :user
end
