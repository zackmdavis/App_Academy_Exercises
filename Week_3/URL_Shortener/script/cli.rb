require 'launchy'

puts "Enter your email--"
input = gets.chomp
user = User.find_by_email(input)
puts "What do you want to do?\n1. Create shortened URL\n2. Visit shortened URL"
input = gets.chomp
option = input.to_i
case option
when 1
  puts "Type in your long URL--"
  long_url = gets.chomp
  shortened_url = ShortenedUrl.create_for_user_and_long_url!(user, long_url)
  puts "Your shortened url is: #{shortened_url.short_url}"
when 2
  puts "Enter shortened URL--"
  short_url = gets.chomp
  shortened_url_object = ShortenedUrl.find_by_short_url(short_url)
  long_url = shortened_url_object.long_url
  Visit.record_visit!(user, shortened_url_object)
  Launchy.open(long_url)
end