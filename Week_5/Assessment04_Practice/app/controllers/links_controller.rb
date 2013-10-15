class LinksController < ApplicationController

  def index
    @links = Link.all
    show :index
  end

  def show
    @link = Link.find(params[:id])
  end

end
