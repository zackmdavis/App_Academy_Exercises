class UsersController < ApplicationController

  def index
    @users = User.all
    render :json => @users
  end

  def create
    puts params
    user = User.new(params[:user])
    puts user
    if user.save
      render :json => user
    else
      render :json => user.errors
    end
  end

  def show
    @user = User.find(params[:id])
    render :json => @user
  end

  def destroy
    @user = User.find(params[:id])
    @user.delete
    render :text => "user deleted??"
  end

end
