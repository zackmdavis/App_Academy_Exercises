class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(params["user"]["username"],
                                    params["user"]["password"])

    unless user.nil?
      login!(user)

      redirect_to cats_url
    else
      flash[:errors] ||= []
      flash[:errors] << "Incorrect username or password!"

      render :new
    end
  end

  def destroy
    session[:session_token] = nil

    flash[:messages] ||= []
    flash[:messages] << "You have been successfully logged out!"
    redirect_to cats_url
  end
end
