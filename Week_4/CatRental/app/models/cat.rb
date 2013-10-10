class Cat < ActiveRecord::Base
  attr_accessible :age, :birth_date, :color, :name, :sex
  validates :age, :birth_date, :color, :name, :sex, :presence => true
  validates :age, :numericality => true
  validates :sex, :inclusion => { :in => %w[M F], :message => "Sex must be 'M' or 'F'" }
  validates :color, :inclusion => { :in => %w[black gray brown calico white other], :message => "Not a valid color" }

  has_many( :rental_requests,
    :class_name => "RentalRequest",
    :primary_key => :id,
    :foreign_key => :cat_id,
    :dependent => :destroy
  )

  def attributes
    attributes = {:name => name, :age => age, :birth_date => birth_date, :color => color, :sex => sex}
  end

end
