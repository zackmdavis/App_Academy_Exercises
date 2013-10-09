class Contact < ActiveRecord::Base
  attr_accessible :email, :name, :user_id, :favorite
  validates :email, :name, :user_id, :presence => true

  belongs_to :user

  def self.contacts_for_user_id(user_id)
    Contact.joins('LEFT JOIN contact_shares ON contact_shares.contact_id = contacts.id')
    .where('contacts.user_id = ? OR contact_shares.user_id = ?', user_id, user_id)
  end

end
