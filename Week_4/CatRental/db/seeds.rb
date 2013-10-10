# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c1 = Cat.create!(:name => "Jennifer", :age => 5, :birth_date => "08-Jan-2012", :color => "white", :sex => 'F')
c2 = Cat.create!(:name => "Spike", :age => 2, :birth_date => "12-Feb-2008", :color => "gray", :sex => 'M')