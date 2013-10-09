class ContactSharesController < ApplicationController

  def create
    @contact_share = ContactShare.new(params[:contact_share])
    if @contact_share.save
      render :json => @contact_share
    else
      render :json => @contact_share.errors
    end
  end

  def destroy
    @contact_share = ContactShare.find(params[:id])
    @contact_share.delete
    head :ok
  end

end
