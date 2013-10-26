class SecretTagging < ActiveRecord::Base
  attr_accessible :secret_id, :tag_id
  validates :secret_id, :tag_id, presence: true
  validates :secret_id, uniqueness: {:scope => :tag_id}

  belongs_to :secret
  belongs_to :tag
end
