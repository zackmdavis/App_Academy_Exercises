class AlbumsController < ApplicationController

  def index
    @albums = Album.all
    render :index
  end

  def new
    @album = Album.new
    render :new
  end

  def create
    @album = Album.new(params[:album])
    if @album.save
      render :show
    else
      flash_error("something went wrong; could not create album")
      render :new
    end
  end

  def show
    @album = Album.find(params[:id])
    render :show
  end

  def edit
    @album = Album.find(params[:id])
    render :edit
  end

  def update
    @album = Album.find(params[:id])
    if @album.update_attributes(params["album"])
      render :show
    else
      flash_error("something went wrong!!---could not edit album")
      render :edit
    end
  end

  def destroy
    Album.find(params[:id]).destroy
    flash_message("Album destroyed!!")
    render :index
  end

end
