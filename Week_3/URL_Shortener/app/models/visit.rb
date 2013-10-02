class Visit < ActiveRecord::Base
  attr_accessible :visitor_id, :shortened_url_id

  belongs_to(
  :user,
  :class_name => "User",
  :foreign_key => :visitor_id,
  :primary_key => :id
  )

  belongs_to(
  :shortened_url,
  :class_name => "ShortenedUrl",
  :foreign_key => :shortened_url_id,
  :primary_key => :id
  )

  def self.record_visit!(user, shortened_url)
    options_hash = { visitor_id: user.id, shortened_url_id: shortened_url.id}
    create(options_hash)
  end

end
