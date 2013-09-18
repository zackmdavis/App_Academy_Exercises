class Student
  attr_accessor :first, :last, :courses

  def initialize(first, last)
    @first = first
    @last = last
    @courses = []
  end

  def name
    @first + " " + @last
  end

  def enroll(course)
    @courses.each do |existing_course|
      if course.conflicts_with?(existing_course)
        raise "Conflicting course"
      end
    end
    @courses.push(course)
    course.students.push(self)
  end

  def course_load
    {}.tap do |load|
      @courses.each do |course|
        if load.include? course.department
          load[department] += course.credits
        else
          load[department] = course.credits
        end
      end
    end
  end
end


class Course

  attr_accessor :title, :department, :credits, :days, :timeblock, :students

  def initialize(title, department, credits, days, timeblock)
    @title = title
    @department = department
    @credits = credits
    @days = days
    @timeblock = timeblock
    @students = []
  end

  def add_student(student)
    student.enroll(self)
  end

  def conflicts_with?(course)
    (course.days & self.days) && (course.timeblock == self.timeblock)
  end
end