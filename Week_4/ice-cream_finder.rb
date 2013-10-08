require 'json'
require 'nokogiri'
require 'rest-client'
require 'addressable/uri'
require './api_key'

class IceCreamFinder

  include ApiKey

  def find_lat_long_from_address
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
    lat_lng = "#{lat},#{lng}"
  end

  def find_nearby_places(coordinates)
    search_url = Addressable::URI.new(
    :scheme => "https",
    :host => "maps.googleapis.com",
    :path => "maps/api/place/nearbysearch/json",
    :query_values => {:key => api_key, :location => coordinates,
                      :radius => "1500", :keyword => "ice cream", :sensor => "false"}).to_s

    search_json = RestClient.get(search_url)
    search_hash = JSON.parse(search_json)

    places = search_hash["results"][0..2]
    places.map! { |place| [place["name"], place["vicinity"], coordinates] }
  end

  def get_directions_hash_for_place(place)
    directions_url = Addressable::URI.new(
    :scheme => "https",
    :host => "maps.googleapis.com",
    :path => "maps/api/directions/json",
    :query_values => {:origin => place[2], :destination => place[1], :sensor => "false"}).to_s

    directions_json = RestClient.get(directions_url)
    directions_hash = JSON.parse(directions_json)
    directions_hash
  end

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
    plain_directions.gsub("Destination will be", "\nDestination will be")+"\n"
  end

  def display(place, plain_directions)
    puts place[0]
    puts place[1], "\n"
    puts "Directions:"
    puts plain_directions
  end

  def run
    coordinates = find_lat_long_from_address
    places = find_nearby_places(coordinates)
    puts "Nearby ice-cream follows!---\n"
    places.each do |place|
      directions = get_directions_hash_for_place(place)
      steps = steps_from_directions_hash(directions)
      display(place, steps)
      puts "----------"
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  IceCreamFinder.new.run
end
