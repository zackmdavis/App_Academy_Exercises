require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :email, :password, :active, :activation_token

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.generate_activation_token
    SecureRandom.urlsafe_base64(9)
  end

  def self.find_by_credentials(email, pass)
    user = User.find_by_email(email)
    if user and user.is_password?(pass)
      return user
    else
      return nil
    end
  end

  def reset_activation_token!
    self.activation_token = self.class.generate_activation_token
    self.save
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save
  end

  def password=(pass)
    self.password_digest = BCrypt::Password.create(pass)
  end

  def is_password?(pass)
    BCrypt::Password.new(self.password_digest).is_password?(pass)
  end

  def active?
    !!active
  end

end
