require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :email, :password_digest, :session_token, :reset_token

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def find_by_credentials(email, pass)
    u = User.find_by_email(email)
    return u if u and u.is_password?(pass)
    nil
  end

  def password=(pass)
    self.password_digest = BCrypt::Password.create(pass)
  end

  def is_password?(pass)
    BCrypt::Password.new(self.password_digest).is_password?(pass)
  end

  def reset_session_token
    self.session_token = User.generate_session_token
  end

end
