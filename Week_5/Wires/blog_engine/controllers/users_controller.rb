require_relative '../../lib/wires'
require_relative '../../lib/sedentaryrecord'
require_relative '../models/post'

class UsersController < ControllerBase

  def index
    @users = User.all
    render :index
  end

  def show
    @user = User.find(@params["id"])
    render :show
  end

end
