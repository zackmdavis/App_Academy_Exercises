require_relative '../../lib/wires'
require_relative '../../lib/sedentaryrecord'
require_relative '../models/post'
require_relative '../models/user'

class PostsController < ControllerBase

  def index
    @posts = Post.all
    render :index
  end

  def show
    @post = Post.find(@params["id"])
    render :show
  end

  def new
    render :new
  end

  def create
    @post = Post.new(@params["post"])
    @post.id = nil
    @post.save
    redirect_to("/posts")
  end

end
