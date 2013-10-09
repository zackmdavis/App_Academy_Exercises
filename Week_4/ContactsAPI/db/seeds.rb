# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user1 = User.create!(:name => "David", :email => "david@david.com")
user2 = User.create!(:name => "Zack", :email => "zack@zack.com")
user3 = User.create!(:name => "John", :email => "john@john.com")

contact1 = Contact.create!(:name => "Carly Fiona", :email => "c@hp.com", :user_id => 1)
contact2 = Contact.create!(:name => "Bill DiMaggio", :email => "b@b.org", :user_id => 2)
contact3 = Contact.create!(:name => "Tara Strong", :email => "t@dsijogh.com", :user_id => 1)

share1 = ContactShare.create!(:user_id => 1, :contact_id => 2)
share2 = ContactShare.create!(:user_id =>2, :contact_id => 3)

