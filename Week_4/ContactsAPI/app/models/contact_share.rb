class ContactShare < ActiveRecord::Base
  attr_accessible :contact_id, :user_id
  validates :contact_id, :user_id, :presence => true

  belongs_to :contact
  belongs_to(
  :shared_user,
  :primary_key => :id,
  :foreign_key => :user_id,
  :class_name => 'User'
  )

end
