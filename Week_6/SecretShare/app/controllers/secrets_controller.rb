class SecretsController < ApplicationController

  def new
    render :new
  end

  def create
    @secret = Secret.new(params[:secret])
    @secret.author_id = current_user.id
    if @secret.save
      redirect_to user_url(params[:secret][:recipient_id])
    else
      render :json => "ERROR"
    end
  end

end
