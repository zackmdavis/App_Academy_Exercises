class SecretsController < ApplicationController

  def new
    render :new
  end

  def create
    @secret = Secret.new(params[:secret])
    @secret.author_id = current_user.id
    if @secret.save
      render :json => @secret
    else
      render :json => "ERROR"
    end
  end

end
