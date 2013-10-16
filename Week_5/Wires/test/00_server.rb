require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/wires'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
    #render_content("hello world!", "text/html")
    #redirect_to('http://zackmdavis.net/blog')
    # after you have template rendering, uncomment:
    # @title = "This is the Title"
#     render :show

    # after you have sessions going, uncomment:
   session["count"] ||= 0
   session["count"] += 1
   render :counting_show
  end
end

server.mount_proc '/' do |req, res|
  MyController.new(req, res).go
end

server.start
