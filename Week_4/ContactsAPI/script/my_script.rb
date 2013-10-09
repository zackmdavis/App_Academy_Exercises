require 'addressable/uri'
require 'rest-client'

url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/contacts/4',
  query_values: {

    }
).to_s

puts RestClient.put(url, :contact => {:name => "Frankie Foster"})