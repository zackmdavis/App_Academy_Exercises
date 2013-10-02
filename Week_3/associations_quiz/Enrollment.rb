class Enrollment < ActiveRecord::Base
  attr_accessible :user_id, :course_id
  belongs_to(
  :user,
  :class_name => "User",
  :foreign_key => :user_id,
  :primary_key => :id
  )

  belongs_to(
  :course,
  :class_name => "Course",
  :foreign_key => :course_id,
  :primary_key => :id
  )

end