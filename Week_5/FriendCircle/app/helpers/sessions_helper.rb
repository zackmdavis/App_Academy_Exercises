module SessionsHelper

  def current_user=(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def logged_in?
    !!current_user
  end

  def login!(user)
    user.reset_session_token!
    self.current_user = user
  end

  def logout!
    self.current_user.reset_session_token!
    session[:session_token] = SecureRandom.urlsafe_base64(6)
  end

end
