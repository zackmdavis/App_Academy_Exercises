# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u1 = User.create(:email => "a@a.com", :password => "a")
u2 = User.create(:email => "b@b.net", :password => "b")
u3 = User.create(:email => "c@c.org", :password => "c")
u4 = User.create(:email => "d@d.co.uk", :password => "d")

c1 = Circle.create(:name => "First Friend Circle", :user_id => 1)
c2 = Circle.create(:name => "Second Friend Circle", :user_id => 1)

cm1 = CircleMembership.create(:circle_id => 1, :circled_id => 2)
cm2 = CircleMembership.create(:circle_id => 1, :circled_id => 3)
cm3 = CircleMembership.create(:circle_id => 2, :circled_id => 2)