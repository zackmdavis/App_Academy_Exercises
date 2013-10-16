require 'active_support/core_ext'
require 'webrick'

first_server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { first_server.shutdown }

first_server.mount_proc '/' do |req, res|
  path = req.path
  message = %Q[Hello, world! I see you have requested the resource at #{path}.
Regretfully, that resource is unavailable right now. However, I remain,

Your faithful correspondent,
M. First Server, Esq.]
  res.content_type = 'text/text'
  res.body = message
end

first_server.start