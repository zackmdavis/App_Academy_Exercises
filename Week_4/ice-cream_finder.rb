require 'json'
require 'nokogiri'
require 'rest-client'
require 'addressable/uri'
require './api_key'
include ApiKey

def ice_cream
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

lat = location_coordinates["lat"].to_s
lng = location_coordinates["lng"].to_s

search_url = Addressable::URI.new(
:scheme => "https",
:host => "maps.googleapis.com",
:path => "maps/api/place/nearbysearch/json",
:query_values => {:key => api_key, :location => "#{lat},#{lng}",
                  :radius => "1500", :keyword => "ice cream", :sensor => "false"}).to_s

search_json = RestClient.get(search_url)
search_hash = JSON.parse(search_json)

places = search_hash["results"][0..2]
places.map! { |place| [place["name"], place["vicinity"]] }

address = places[0][1]

directions_url = Addressable::URI.new(
:scheme => "https",
:host => "maps.googleapis.com",
:path => "maps/api/directions/json",
:query_values => {:origin => "#{lat},#{lng}", :destination => address, :sensor => "false"}).to_s

directions_json = RestClient.get(directions_url)
directions_hash = JSON.parse(directions_json)
directions_hash

def steps_from_directions_hash(directions)
  readable_directions = ""
  route = directions["routes"][0]
  legs = route["legs"]
  legs.each do |leg|
    steps = leg["steps"]
    steps.each do |step|
      readable_directions += step["html_instructions"]+"\n"
    end
  end
  plain_directions = Nokogiri::HTML(readable_directions).text
  plain_directions = plain_directions.gsub("Destination will be", "\nDestination will be")+"\n"
end

puts "The nearest ice-cream parlor is"
puts places[0][0]
puts address
puts "Directions follow---"
puts
print steps_from_directions_hash(directions_hash)

end

ice_cream