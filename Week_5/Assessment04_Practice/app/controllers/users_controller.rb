class UsersController < ApplicationController

  def new
    flash[:errors] ||= []
    render :new
  end

  def create
    flash[:errors] ||= []
    @user = User.find_by_username(params["user"]["Username"])
    if @user.nil?
      flash[:errors] << "No user found"
      redirect_to new_user_url
      return
    end

    if @user.password != params["Password"]
      flash[:errors] << @user.errors.full_messages
      redirect_to new_user_url
      return
    end
    if @user.save
      render "links#index"
    else
      flash[:errors] << @user.errors.full_messages
      render :new
    end
  end

  def edit

  end

  def update

  end

  def index

  end

  def show

  end

  def destroy

  end



end
