class TracksController < ApplicationController

  def new
    @track = Track.new
    render :new
  end

  def create
    @track = Track.new(params[:track])
    if @track.save
      render :show
    else
      flash_error("something went wrong; could not create track")
      render :new
    end
  end

  def show
    @track = Track.find(params[:id])
    render :show
  end

  def edit
    @track = Track.find(params[:id])
    render :edit
  end

  def update
    @track = Track.find(params[:id])
    if @track.update_attributes(params["track"])
      render :show
    else
      flash_error("something went wrong!!---could not edit track")
      render :edit
    end
  end

  def destroy
    @track = Track.find(params[:id])
    @album_id = @track.album_id
    @track.destroy
    flash_message("Track destroyed!!")
    redirect_to album_url(@album_id)
  end

end
