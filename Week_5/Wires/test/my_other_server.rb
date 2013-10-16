require 'active_support/core_ext'
require 'webrick'

first_server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { first_server.shutdown }

first_server.mount_proc '/' do |request, response|
  p "REQUEST ATTRIBUTES"
  p request.attributes
  p request.addr
  p request.body
  p request.query
  p request.path

end

first_server.start