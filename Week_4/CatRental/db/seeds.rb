# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

c1 = Cat.create!(:name => "Jennifer", :age => 1, :birth_date => "08-Jan-2012", :color => "white", :sex => 'F')
c2 = Cat.create!(:name => "Spike", :age => 2, :birth_date => "12-Feb-2011", :color => "brown", :sex => 'M')
c3 = Cat.create!(:name => "Rainbow Dash", :age => 3, :birth_date => "22-Feb-2010", :color => "calico", :sex => 'M')
c4 = Cat.create!(:name => "Twilight Sparkle", :age => 4, :birth_date => "04-Apr-2009", :color => "gray", :sex => 'F')
c5 = Cat.create!(:name => "Emperor Norton", :age => 5, :birth_date => "01-Dec-2008", :color => "other", :sex => 'M')

RentalRequest.create!(:cat_id => 1, :start_date => Date.new(1991, 6, 1), :end_date => Date.new(1994, 1, 1))
RentalRequest.create!(:cat_id => 1, :start_date => Date.new(1991, 6, 1), :end_date => Date.new(1994, 1, 1))
RentalRequest.create!(:cat_id => 1, :start_date => Date.new(1991, 6, 1), :end_date => Date.new(1994, 1, 1))
