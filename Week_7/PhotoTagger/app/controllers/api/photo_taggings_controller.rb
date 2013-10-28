class Api::PhotoTaggingsController < ApplicationController
  before_action :require_current_user!, :only => [:create]

  def index
    @photo_taggings = PhotoTagging.all

    render :json => @photo_taggings
  end

  def create
    @photo_tagging = PhotoTagging.new(params[:photo_tagging])

    if @photo_tagging.save
      render :json => @photo_tagging
    else
      render :json => { :errors => @photo_tagging.errors.full_messages }, :status => 422
    end

  end
end
