class Tag < ActiveRecord::Base
  attr_accessible :tag_name

  has_many(
  :taggings,
  :class_name => "Tagging",
  :foreign_key => :tag_id,
  :primary_key => :id
  )

  has_many :tagged_urls, :through => :taggings, :source => :shortened_urls
end
