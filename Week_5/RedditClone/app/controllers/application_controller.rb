class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

  def flash_error(text)
    flash[:errors] ||= []
    flash[:errors] << text
  end

  def flash_message(text)
    flash[:messages] ||= []
    flash[:messages] << text
  end

end
