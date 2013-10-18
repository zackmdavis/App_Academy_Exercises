class LinksController < ApplicationController

  def new
    @link = Link.new
    @sub_id =  params[:sub_id]
    render :new
  end

  def create
    @link = Link.new(params[:link])
    @link.submitter_id = current_user.id
    if @link.save
      redirect_to sub_link_url(@link.sub_id, @link)
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
