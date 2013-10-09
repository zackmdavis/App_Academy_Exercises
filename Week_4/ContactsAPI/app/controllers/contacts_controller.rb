class ContactsController < ApplicationController

  def index
    # old version---
    # @user = User.find(params[:user_id])
    # @contacts = @user.contacts
    # @contact_shares = @user.contact_shares.map { |share| Contact.find(share.contact_id) }
    @contacts = Contact.contacts_for_user_id(params[:user_id])
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
    @contact = Contact.new(params[:contact])
    if @contact.save
      render :json => @contact
    else
      render :json => @contact.errors
    end
  end

  def update
    @contact = Contact.find(params[:id])
    @contact.assign_attributes(params[:contact])
    if @contact.save
      render :json => @contact
    else
      render :json => @contact.errors
    end
  end

  def favorites
    @contacts = Contact.contacts_for_user_id(params[:user_id]).where(:favorite => true)
    render :json => @contacts
  end

end
