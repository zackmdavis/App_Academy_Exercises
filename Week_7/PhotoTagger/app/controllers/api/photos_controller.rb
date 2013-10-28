class Api::PhotosController < ApplicationController
  def index
    @photos = Photo.find_all_by_owner_id(params[:user_id])

    respond_to do |format|
      format.html
      format.json { render :json => @photos.to_json }
    end

  end

  def create
    puts params
    @photo = Photo.new({:owner_id => params[:owner_id], :title => params[:title],
                        :url => params[:url] })
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
