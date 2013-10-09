class ContactShare < ActiveRecord::Base
  attr_accessible :contact_id, :user_id

  has_one :shared_by_user, :through => :contact_id, :source => :user



end
