class UsersController < ApplicationController

  def new
    render :new
  end

  def create
    if params["user"]["password"] != params["confirm_password"]
      flash[:errors] ||= []
      flash[:errors] << "Password confirmation doesn't match!"
      render :new
    else
      @user = User.new(params["user"])
      if @user.save
        login!(@user)
        redirect_to cats_url
      else
        flash[:errors] ||= []
        flash[:errors] << "Something went wrong!"
        render :new
      end
    end
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end

end
