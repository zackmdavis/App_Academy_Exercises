class User < ActiveRecord::Base
  attr_accessible :email, :name
  validates :name, :email, :presence => true

  has_many :contacts, :class_name => "Contact", :foreign_key => :user_id
end
