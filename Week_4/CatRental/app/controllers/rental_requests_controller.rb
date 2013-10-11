class RentalRequestsController < ApplicationController

  include RentalRequestsHelper

  def index
    @cat = Cat.find(params[:cat_id])
    @rental_requests = @cat.rental_requests
    render :index
  end

  def new
    @rental_request = RentalRequest.new
    @rental_request.start_date = Date.new(1990, 1, 1)
    @rental_request.end_date = Date.new(1990, 1, 1)
    @cats = Cat.all
    render :new
  end

  def create
    request_options = params[:rental_request]
    request_options[:start_date] = date_helper(request_options[:start_date])
    request_options[:end_date] = date_helper(request_options[:end_date])
    @rental_request = RentalRequest.new(request_options)
    @cat = Cat.find(@rental_request.cat_id)
    if @rental_request.save
      render :show
    else
      render :json => "ERROR CREATING REQUEST"
    end
  end

  def show
    @rental_request = RentalRequest.find(params[:id])
    @cat = Cat.find(@rental_request.cat_id)
    render :show
  end

  def edit
    @rental_request = RentalRequest.find(params[:id])
    @cats = Cat.all
    render :edit
  end

  def update
    request_options = params[:rental_request]
    request_options[:start_date] = date_helper(request_options[:start_date])
    request_options[:end_date] = date_helper(request_options[:end_date])
    @rental_request = RentalRequest.new(request_options)
    @cat = Cat.find(@rental_request.cat_id)
    if @rental_request.update_attributes(params[:rental_request])
      render :show
    else
      render :json => "ERROR CREATING REQUEST"
    end
  end

  def destroy
    RentalRequest.find(params[:id]).destroy
    render :index
  end

  def approve
    @rental_request = RentalRequest.find(params[:id])
    @rental_request.approve!
    redirect_to cat_url(@rental_request.cat_id)
  end

  def deny
    @rental_request = RentalRequest.find(params[:id])
    @rental_request.deny!
    redirect_to cat_url(@rental_request.cat_id)
  end

end
