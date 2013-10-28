class Api::PhotosController < ApplicationController
  def index
    @photos = Photo.find_by_owner_id(params[:user_id])

    respond_to do |format|
      format.html
      format.json { render :json => @photos.to_json }
    end

  end

  def create
    @photo = Photo.new(params[:photo]);

    if @photo.save
      render :json => @photo
    else
      render :json => { :errors => @photo.errors.full_messages }, :status => 422
    end
  end

  def show
    @photo = Photo.find(params[:id])

    render :json => @photo
  end
end
