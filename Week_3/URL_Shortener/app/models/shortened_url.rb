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
    short_url_candidate = self.unique_random_code
    options_hash = {:long_url => long_url, :submitter_id => user.id,
      :short_url => short_url_candidate }
    shortened_url_candidate = create(options_hash)
  end

end
