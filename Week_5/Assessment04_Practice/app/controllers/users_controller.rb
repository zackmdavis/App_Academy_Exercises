class UsersController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create

    @user = User.new(params[:user])
    if @user.save
      session[:session_token] = @user.reset_session_token!
      redirect_to "links#index"
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end

    # I am rather upset that this isn't working, so I am going to go look at the solutions for this part
    #
    # flash[:errors] ||= []
    # @user = User.find_by_username(params["user"]["Username"])
    # if @user.nil?
    #   flash[:errors] << "No user found"
    #   redirect_to new_user_url
    #   return
    # end
    #
    # if @user.password != params["Password"]
    #   flash[:errors] << @user.errors.full_messages
    #   redirect_to new_user_url
    #   return
    # end
    # if @user.save
    #   render "links#index"
    # else
    #   flash[:errors] << @user.errors.full_messages
    #   render :new
    # end
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
