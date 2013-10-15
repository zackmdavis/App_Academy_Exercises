class User < ActiveRecord::Base

  attr_accessible :username, :password, :session_token

  validates :username, :password, :presence => true
  validates :password, :length => {:minimum => 6}

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(10)
    self.save
    self.session_token
  end

  # attr_accessible :password, :username
  # attr_accessor :password
  # validate :username_cannot_be_blank, :password_cannot_be_blank, :password_must_be_long_enough
  #
  #
  # def username_cannot_be_blank
  #   if self.username.nil? or self.username == ''
  #     flash[:errors] << "Username can't be blank"
  #   end
  # end
  #
  # def password_cannot_be_blank
  #   if self.password.nil? or self.password == ''
  #     self.errors << "Password can't be blank"
  #   end
  # end
  #
  # def password_must_be_long_enough
  #   if self.password.length < 6
  #     self.errors << "Password is too short"
  #   end
  # end


end
