class PastesController < ApplicationController

  def index
    @pastes = Paste.find_all_by_owner_id(current_user)
    render :json => @pastes
  end

  def show
    @paste = Paste.find(params[:id])
    render :json => @paste
  end

end
