# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

p1 = Post.create(:title => "The First Post", :body => %Q[<p>This is the first post.</p>
  <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem
  Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown
  printer took a galley of type and scrambled it to make a type specimen book. It has survived
  not only five centuries, but also the leap into electronic typesetting, remaining essentially
  unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem
  Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker
  including versions of Lorem Ipsum.</p>
  ])

p2 = Post.create(:title => "The Post About Dolphins", :body => %Q[
  <p>Some dolphins are not very nice. Names of non-nice dolphins include:</p>
  <ul>
    <li>Sandy</li>
    <li>Catherine</li>
    <li>Sparky</li>
  </ul>
  <p>Dolphins are marine mammals closely related to whales and porpoises. There
  are almost forty species of dolphin in 17 genera.</p>
  ])