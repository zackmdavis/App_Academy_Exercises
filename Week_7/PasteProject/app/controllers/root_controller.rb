class RootController < ApplicationController

  before_filter :require_current_user!


  def root
    render "./home"
  end

end