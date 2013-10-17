class LinksController < ApplicationController

  def new
    @link = Link.new
    render :new, :sub_id => params[:sub_id]
  end

  def create
    @link = Link.new(params[:link])
    if @link.save
      redirect_to link_url(@link)
    else
      flash[:errors] = @link.errors.full_messages
      render :new
    end
  end

  def show
    @link = Link.find(params[:id])
    render :show
  end

end
