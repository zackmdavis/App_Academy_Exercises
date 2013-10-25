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
    @friendship = Friendship.find(params[:id])
    if @friendship
      @friendship.destroy
      render :json => "destroyed successfully"
    else
      render :json => "ERROR - friendship not found"
    end
  end
end
