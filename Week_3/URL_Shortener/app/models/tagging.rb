class Tagging < ActiveRecord::Base
  attr_accessible :tagged_url_id, :tag_id

  belongs_to(
  :shortened_urls,
  :class_name => "ShortenedUrl",
  :foreign_key => :tagged_url_id,
  :primary_key => :id
  )

  belongs_to(
  :tags,
  :class_name => "Tag",
  :foreign_key => :tag_id,
  :primary_key => :id
  )


end
