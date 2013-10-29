class PostsController < ApplicationController

  def index
    @posts = Post.all
    respond_to do |format|
      format.html { render :index }
      format.json { render :json => @posts }
    end
  end

  def show
    @post = Post.find(params[:id])
    render :json => @post
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      render :json => @post
    else
      render :json => @post.errors.full_messages
    end
  end

end
