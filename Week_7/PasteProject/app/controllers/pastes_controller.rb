class PastesController < ApplicationController

  def index
    @pastes = Paste.includes(:favorite).find_all_by_owner_id(current_user)
    render :json => @pastes, :include => :favorite
  end

  def show
    @paste = Paste.find(params[:id])
    render :json => @paste
  end

  def create
    @paste = Paste.new(params[:paste])
    @paste[:owner_id] = current_user.id
    if @paste.save
      render :json => @paste
    else
      render :json => @paste.errors.full_messages, status: 422
    end
  end
end
