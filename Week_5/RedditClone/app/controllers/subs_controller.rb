class SubsController < ApplicationController

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.create(params[:sub])
    @sub.mod_id = current_user.id
    valid_links = params[:links].values.select do |link|
      !link["url"].empty? && !link["title"].empty?
    end
    @sub.links.build(valid_links)
    @sub.links.each { |link| link.submitter_id = current_user.id }

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def index
    @subs = Sub.all
    render :index
  end

  def show
    @sub = Sub.find(params[:id])
    render :show
  end


end
