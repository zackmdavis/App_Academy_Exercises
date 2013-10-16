require 'active_support/core_ext'
require 'json'
require 'webrick'
require_relative '../lib/wires'

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class StatusController < ControllerBase
  def index
    statuses = ["s1", "s2", "s3"]

    render_content(statuses.to_json, "text/json")
  end

  def show
    p params
    p @params
    render_content("status ##{@params["id"]}", "text/text")
  end
end

class UserController < ControllerBase
  def index
    users = ["u1", "u2", "u3"]

    render_content(users.to_json, "text/json")
  end
end

server.mount_proc '/' do |req, res|
  router = Router.new
  router.draw do
    get Regexp.new("^/statuses$"), "StatusController", :index
    get Regexp.new("^/users$"), "UserController", :index
    get Regexp.new("^/statuses/(?<id>\\d+)$"), "StatusController", :show
  end

  route = router.run(req, res)
end

server.start
