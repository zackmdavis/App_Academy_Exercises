class CirclesController < ApplicationController

  def new
    @user = User.find(params[:user_id])
    render :new
  end

  def create

  end

end
