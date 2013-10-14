class ArtistsController < ApplicationController

  def index
    @artists = Artist.all
    render :index
  end

  def new
    @artist = Artist.new
    render :new
  end

  def create
    @artist = Artist.new(params[:artist])
    if @artist.save
      render :show
    else
      flash_error("something went wrong; could not create artist")
      render :new
    end
  end

  def show
    @artist = Artist.find(params[:id])
    render :show
  end

  def edit
    @artist = Artist.find(params[:id])
    render :edit
  end

  def update
    @artist = Artist.find(params[:id])

    if @artist.update_attributes(params[:artist])
      render :show
    else
      flash_error("something went wrong!!---could not edit artist")
      render :edit
    end
  end

  def destroy
    Artist.find(params[:id]).destroy
    flash_message("Artist destroyed!!")
    render :index
  end

end
