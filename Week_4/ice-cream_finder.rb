require 'json'
require 'rest-client'
require 'addressable/uri'

# puts "What is your current address??"
# address_input = gets.chomp
address_input = "1061 Market St, San Francisco, CA"
location_url = Addressable::URI.new(
  :scheme => "http",
  :host => "maps.googleapis.com",
  :path => "maps/api/geocode/json",
  :query_values => {:address => address_input, :sensor => "false"}).to_s
location_json = RestClient.get(location_url)
location_hash = JSON.parse(location_json)
location_coordinates = location_hash["results"][0]["geometry"]["location"]
p location_coordinates
