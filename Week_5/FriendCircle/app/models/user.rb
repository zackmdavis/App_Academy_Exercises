require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :email, :password, :session_token, :reset_token
  validates :email, :uniqueness => true

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.generate_reset_token
    SecureRandom.urlsafe_base64(12)
  end

  def self.find_by_credentials(email, pass)
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

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save
    self.session_token
  end

  def reset_reset_token!
    self.session_token = User.generate_reset_token
    self.save
    self.reset_token
  end

end
