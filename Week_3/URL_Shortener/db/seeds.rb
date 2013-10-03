# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Tag.create(tag_name: "news")
Tag.create(tag_name: "technology")
Tag.create(tag_name: "science")
Tag.create(tag_name: "philosophy")
Tag.create(tag_name: "sports")