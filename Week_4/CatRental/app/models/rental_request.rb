class RentalRequest < ActiveRecord::Base
  attr_accessible :cat_id, :start_date, :end_date, :status
  before_validation :ensure_pending_if_unspecified
  validates :cat_id, :start_date, :end_date, :status, :presence => true
  validates :status, :inclusion => { :in => %w[PENDING APPROVED DENIED] }
  validate :approved_requests_do_not_overlap

  belongs_to(
    :rental_requests,
    :class_name => "Cat",
    :primary_key => :id,
    :foreign_key => :cat_id
  )

  def ensure_pending_if_unspecified
    status ||= "PENDING"
  end

  def attributes
    attributes = {:start_date => start_date, :end_date => end_date, :status => status}
  end

  def overlapping_requests
    RentalRequest.where('start_date BETWEEN ? AND ? OR end_date BETWEEN ? AND ?',
              start_date, end_date, start_date, end_date).where('id != ?', id)
  end

  def overlapping_approved_requests
    overlapping_requests.where(:status => "APPROVED")
  end

  def approved_requests_do_not_overlap
    unless overlapping_approved_requests.empty?
      errors[:base] << "Cat can only be in one place at one time"
    end
  end
end
