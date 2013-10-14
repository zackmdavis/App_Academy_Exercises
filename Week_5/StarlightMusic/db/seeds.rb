# This file should contain all the record creation needed to seed the database with its default values.

# starting users
u1 = User.new(:email => "a@a.com", :password => "a")
u1.session_token = ''
u1.save

u2 = User.new(:email => "jerrica@starlight.com", :password => "synergy1")
u2.session_token = ''
u2.save

u3 = User.new(:email => "kimber@starlight.com", :password => "trulEoutrag3ous!")
u3.session_token = ''
u3.save

u4 = User.new(:email => "eric_raymond@misfitsmusic.com", :password => "my1averi$e")
u4.session_token = ''
u4.save

# starting artistscreate
a1 = Artist.create(:name => "Jem and the Holograms")
a2 = Artist.create(:name => "The Misfits")
a3 = Artist.create(:name => "The Stingers")

# starting albums
al1 = Album.create(:title => "Only the Beginning", :artist_id => 1)
al2 = Album.create(:title => "Misfits Forever", :artist_id => 2)


# starting tracks
t1 = Track.create(:title => "Only the Beginning", :album_id => 1)
t2 = Track.create(:title => "Getting Down to Business", :album_id => 1)


t20 = Track.create(:title => "Out of My Way", :album_id => 2)
t21 = Track.create(:title => "Winning Is Everything", :album_id => 2)
