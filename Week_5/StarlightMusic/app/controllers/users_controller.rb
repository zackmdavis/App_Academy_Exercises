class UsersController < ApplicationController

  include SessionsHelper

  def index
    @users = User.all
    render :index
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
    @user = User.new(params[:user].merge(:active => false))
    @user.session_token = ''
    @user.activation_token = @user.class.generate_activation_token
    if params["user"]["password"] != params["confirm_password"]
      flash_error("Password confirmation doesn't match!!")
      render :new
    else
      if @user.save
        signup_email = UserMailer.signup_email(@user)
        signup_email.deliver
        flash_message("Check your email to activate your account!")
        redirect_to root_url
      else
        flash_error("something went wrong!!--could not create user")
        render :new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    render :edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      render :show
    else
      flash_error("something went wrong!!---could not update user")
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash_message("User destroyed!!")
    redirect_to root_url
  end

  def activate
    @user = User.find_by_activation_token(params[:activation_token])
    @user.active = true
    if @user.save
      flash_message("Account activated!")
      login!(@user)
      redirect_to root_url
    else
      flash_error("something went wrong!!---could not activate account")
      redirect_to root_url
    end
  end

end
