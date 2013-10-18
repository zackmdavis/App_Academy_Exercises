require_relative '../../lib/wires'
require_relative '../../lib/sedentaryrecord'

class User < SQLObject
  my_attr_accessible :id, :username, :display_name, :password_digest, # not yet-- :session_token
  set_table_name("users")

  has_many :posts, :foreign_key => :author_id, :primary_key => :id, :class_name => "Post"
end