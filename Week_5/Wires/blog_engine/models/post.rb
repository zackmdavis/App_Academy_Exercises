require_relative '../../lib/wires'
require_relative '../../lib/sedentaryrecord'

class Post < SQLObject
  my_attr_accessible :id, :body, :title, :author_id
  set_table_name("posts")
end