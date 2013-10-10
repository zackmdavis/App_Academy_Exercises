class GroupMembership < ActiveRecord::Base
  attr_accessible :contact_id, :group_id

  belongs_to :contact
  belongs_to :group
end
