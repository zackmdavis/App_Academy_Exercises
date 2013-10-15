class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
    if @user
      login!(@user)
      redirect_to user_url(@user.id)
    else
      flash.now[:errors] = ["Please try again."]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to root_url
  end

end
