class FriendshipsController < ApplicationController

  def create
    @friendship = Friendship.new({:in_friend_id => current_user.id, :out_friend_id => params[:user_id]})
    if @friendship.save
      render :json => @friendship
    else
      render :json => @friendship.errors
    end
  end

  def destroy

    @friendship = Friendship.find_by_in_friend_id_and_out_friend_id(current_user.id, params[:out_friend_id])
    if @friendship
      @friendship.destroy
      render :json => {:message => "Success"}
    else
      render :json => "ERROR - friendship not found"
    end
  end
end
