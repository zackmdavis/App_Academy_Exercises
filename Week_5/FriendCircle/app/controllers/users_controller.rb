class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(params[:user])
    if params[:user][:password] != params[:confirm_password]
      flash.now[:errors] = ["Password confirmation doesn't match!!"]
      render :new
    end
    if @user.save
      login!(@user)
      redirect_to user_url(@user.id)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    render :edit
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password] != params[:confirm_password]
      flash.now[:errors] = ["Password confirmation doesn't match!!"]
      render :edit
    end
    if @user.update_attributes(params[:user])
      flash[:messages] = ["User info edited!!"]
      redirect_to user_url(@user.id)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy

  end

  def request_password_reset
    @user = User.find(params[:id])
    reset_password_email = UserMailer.reset_password_email(@user)
    reset_password_email.deliver
    flash[:messages] = ["Check your email"]
    redirect_to root_url
  end

  def password_reset
    @user = User.find_by_reset_token(params[:reset_token])
    if @user
      login!(@user)
      flash[:messages] = ["You've been logged in; now choose a new password"]
      render :edit
    else
      flash.now[:errors] = ["Invalid token; you may be confused"]
    end
  end

end
