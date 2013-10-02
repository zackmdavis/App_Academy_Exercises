class Course < ActiveRecord::Base
  attr_accessible :title, :instructor_id, :prereq_id
  has_many(
    :enrollments,
    :class_name => "Enrollment",
    :foreign_key => :course_id,
    :primary_key => :id
  )

  belongs_to(
  :instructor,
  :class_name => "User",
  :foreign_key => :instructor_id,
  :primary_key => :id
  )

  belongs_to( :prereq,
  class_name: "Course",
  :foreign_key => :prereq_id,
  :primary_key => :id)


  has_one(
  :prereq_of,
  :class_name => "Course",
  :foreign_key => :prereq_id,
  :primary_key => :id
  )

  has_many :students, :through => :enrollments, :source => :user

end