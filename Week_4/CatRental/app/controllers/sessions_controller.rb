class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(params["user"]["username"],
                                    params["user"]["password"])

    unless user.nil?
      login!(user)
      location = request.location.country
      flash[:messages] ||= []
      flash[:messages] << "Logged in from #{location}"
      redirect_to cats_url
    else
      flash[:errors] ||= []
      flash[:errors] << "Incorrect username or password!"

      render :new
    end
  end

  def destroy
    session[:session_token] = ''
    flash[:messages] ||= []
    flash[:messages] << "You have been successfully logged out!"
    redirect_to cats_url
  end
end
