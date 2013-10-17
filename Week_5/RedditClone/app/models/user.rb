class User < ActiveRecord::Base
  attr_accessible :username, :password
  attr_reader :password

  validates :username, :presence => true, :uniqueness => true
  validates :password, :presence => true, :length => { :minimum => 6 },
            :on => :create

  has_many :moderated_subs, :foreign_key => :mod_id, :class_name => "Sub"
  has_many :links, :foreign_key => :submitter_id
  has_many :comments, :foreign_key => :author_id

  def password=(pass)
    @password = pass
    self.password_digest = BCrypt::Password.create(pass)
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.find_by_credentials(username, pass)
    user = User.find_by_username(username)
    if user and user.is_password?(pass)
      return user
    else
      return nil
    end
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save
  end

  def is_password?(pass)
    BCrypt::Password.new(self.password_digest).is_password?(pass)
  end

end
