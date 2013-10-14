class SessionsController < ApplicationController

  include SessionsHelper

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params["user"]["email"], params["user"]["password"])
    unless @user.nil?
      login!(@user)
      flash_message("Logged in!")
      redirect_to user_url(@user.id)
    else
      flash_error("Incorrect username or password!!")
      render :new
    end
  end

  def destroy
    session[:session_token] = ''
    flash_message("You have been successfully logged out!!")
    redirect_to root_url
  end

end
