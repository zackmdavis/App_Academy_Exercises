class FavoritesController < ApplicationController
  def create
    @favorite = Favorite.new(params[:favorite])

    if @favorite.save
      render :json => @favorite
    else
      render :json => @favorite.errors.full_messages, status: 422
    end
  end
end

