require 'securerandom'

class ShortenedUrl < ActiveRecord::Base
  attr_accessible :long_url, :short_url, :submitter_id
  validates :short_url, :uniqueness => true, :presence => true
  validates :long_url, :submitter_id, :presence => true

  has_many(
  :visits,
  :class_name => "Visit",
  :foreign_key => :shortened_url_id,
  :primary_key => :id
  )

  has_many :visitors, :through => :visits, :source => :user

  def self.unique_random_code
    lookup = "start the loop"
    until lookup.nil?
      candidate_url = SecureRandom.urlsafe_base64(6).downcase
      lookup = ShortenedUrl.find_by_short_url(candidate_url)
    end
    candidate_url
  end

  def self.create_for_user_and_long_url!(user, long_url)
    short_url = self.unique_random_code
    options_hash = {:long_url => long_url, :submitter_id => user.id,
      :short_url => short_url }
    create(options_hash)
    self.find_by_short_url(short_url)
  end

  def num_clicks
    Visit.where(shortened_url_id: self.id).count
  end

  def num_uniques
    Visit.where(shortened_url_id: self.id).group('visitor_id').count.count
  end

  def num_recent_clicks(minutes_ago = 5)
    Visit.where(shortened_url_id: self.id, created_at: minutes_ago.minutes.ago .. Time.now).count
  end

end
