module SessionsHelper

  def current_user=(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def current_user
    User.find_by_session_token(session[:session_token])
  end

  def login!(user)
    if user.active?
      user.reset_session_token!
      self.current_user = user
    else
      flash_error("User is inactive!!")
    end
  end

  def logged_in?(user)
    @current_user == user
  end

end
