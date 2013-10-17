require 'active_support/core_ext'
require 'json'
require 'webrick'
require_relative '../lib/wires'
require_relative 'controllers/posts_controller'

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

DBConnection.open('blog_database.db')

server.mount_proc '/' do |request, response|
  router = Router.new
  router.draw do
    get Regexp.new("^/posts$"), "PostsController", :index
    get Regexp.new("^/posts/(?<id>\\d+)$"), "PostsController", :show
    get Regexp.new("^/posts/new$"), "PostsController", :new
    post Regexp.new("^/posts$"), "PostsController", :create

    # TODO
    # get Regexp.new("^/users$"), "UsersController", :index
    # get Regexp.new("^/users/(?<id>\\d+)$"), "UsersController", :show

    # TODO
    # get Regexp.new("^/signup$"), "UsersController", :new
    # get Regexp.new("^/login$"), "SessionsController", :new
    # get Regexp.new("^/logout$"), "SessionsController", :destroy
  end
  route = router.run(request, response)
end

server.start