require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :username, :password

  has_many :cats

  def self.find_by_credentials(username, raw_pass)
    u = User.find_by_username(username)
    if u and u.is_password?(raw_pass)
      return u
    else
      return nil
    end
  end

  def reset_session_token!
     self.session_token = SecureRandom.urlsafe_base64(16)
     self.save
  end

  def password=(raw_pass)
    self.password_digest = BCrypt::Password.create(raw_pass)
  end

  def is_password?(pass)
    BCrypt::Password.new(self.password_digest).is_password?(pass)
  end

end
