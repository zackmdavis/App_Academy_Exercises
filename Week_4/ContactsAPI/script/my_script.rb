require 'addressable/uri'
require 'rest-client'

url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/users/1/contacts',
  query_values: {

    }
).to_s

puts RestClient.get(url)