class UserMailer < ActionMailer::Base
  default from: "helper@friendcircle.infinity"

  def reset_password_email(user)
    @user = user
    @user.reset_reset_token!
    @reset_token = @user.reset_token
    @url = users_passwordreset_url + "?reset_token=#{@reset_token}"
    mail(:to => @user.email, :subject => "your friendly password reset email from Friend Circle")
  end

end
