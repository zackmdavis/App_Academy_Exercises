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
    Track.find(params[:id]).destroy
    flash_message("Track destroyed!!")
    render :index
  end

end
