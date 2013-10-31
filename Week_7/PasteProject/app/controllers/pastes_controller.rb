class PastesController < ApplicationController

  def index
    @pastes = Paste.all# find_by_user_id(current_user)
    render :json => @pastes
  end

end
