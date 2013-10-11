class SessionsController < ApplicationController

  def new

  end

  def create
    p "params hash is", params
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
    self.current_user.reset_session_token!

    session[:session_token] = nil

    flash[:messages] ||= []
    flash[:messages] << "You have been successfully logged out!"
    redirect_to cats_url
  end
end
