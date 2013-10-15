class UserMailer < ActionMailer::Base
  default from: "robot@starlightmusic.com"

  def signup_email(user)
    @user = user
    @activation_token = @user.activation_token
    @url = users_activate_url + "?activation_token=#{@activation_token}"
    mail(:to => @user.email, :subject => "Welcome to Starlight Music")
  end

end
