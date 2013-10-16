require 'active_support/core_ext'
require 'json'
require 'webrick'
require_relative '../lib/wires'

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class ExampleController < ControllerBase
  def create
    render_content(params.to_s, "text/json")
  end

  def new
    page = <<-END
<form action="/" method="post">
  <input type="text" name="cat[name]">
  <input type="text" name="cat[owner]">

  <input type="submit">
</form>
END

    render_content(page, "text/html")
  end
end

server.mount_proc '/' do |req, res|
  case req.path
  when '/'
    contr = ExampleController.new(req, res).create
  when '/new'
    contr = ExampleController.new(req, res).new
  end
end

server.start
