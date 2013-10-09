class ContactsController < ApplicationController

  def index
    @contacts = Contact.all
    render :json => @contacts
  end

  def show
    @contact = Contact.find(params[:id])
    render :json => @contact
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.delete
    head :ok
  end

  def create
    contact = Contact.new(params[:contact])
    if contact.save
      render :json => contact
    else
      render :json => contact.errors
    end
  end

  def update
    contact = Contact.find(params[:id])
    contact.assign_attributes(params[:contact])
    if contact.save
      render :json => contact
    else
      render :json => contact.errors
    end
  end

end
