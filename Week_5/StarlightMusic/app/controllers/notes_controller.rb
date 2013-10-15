class NotesController < ApplicationController

  include SessionsHelper

  def new
    @user = current_user
    if @user.nil?
      flash_error("You must be logged in to create a note!")
      redirect_to login_url
    else
      @note = Note.new
      render :new
    end
  end

  def create
    @user = current_user
    @note = Note.new(params[:note].merge(:user_id => @user.id))
    if @note.save
      flash_message("Created new note!!")
      redirect_to track_url(@note.track_id)
    else
      flash_error("something went wrong; could not create note")
      render :new
    end
  end

  def edit
    @note = Note.find(params[:id])
    render :edit
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params["note"])
      redirect_to track_url(@note.track_id)
    else
      flash_error("something went wrong; could not edit note")
      render :new
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @track_id = @note.track_id
    @note.destroy
    flash_message("Note destroyed!!")
    redirect_to track_url(@track_id)
  end

end
