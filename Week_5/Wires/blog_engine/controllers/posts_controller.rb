require_relative '../../lib/wires'
require_relative '../../lib/sedentaryrecord'
require_relative '../models/post'

class PostsController < ControllerBase

  def index
    render :index
  end

  def show
    @post = Post.find(@params["id"])
    render(:show)
  end

end
