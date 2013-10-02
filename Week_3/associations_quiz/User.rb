class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name
  has_many(
      :enrollments,
      :class_name => "Enrollment",
      :foreign_key => :user_id,
      :primary_key => :id
  )

  has_many(
  :courses_taught,
  :class_name => "Course",
  :foreign_key => :instructor_id,
  :primary_key => :id
  )

  has_many :courses, :through => :enrollments, :source => :course

end