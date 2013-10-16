class CirclesController < ApplicationController

  def new
    @user = User.find(params[:user_id])
    render :new
  end

  def create
    @circle = Circle.new(params[:circle])
    @circle.user_id = current_user.id
    if @circle.save
      flash[:messages] = ["Circle created!!"]
      redirect_to user_url(params[:user_id])
    else
      flash.now[:errors] = ["Could not create circle!!"]
      render :new
    end
  end

end
