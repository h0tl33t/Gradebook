class Student < User
  attr_writer :gpa
  
  has_many :enrollments, foreign_key: 'student_id', dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course
  
  scope :with_grades_for, lambda {|course| joins(:enrollments).where(enrollments: {course: course}).select('users.*, enrollments.grade as grade')}
  
  def courses_for(semester)
    courses_with_grades = enrolled_courses.for_semester(semester).with_grades_for(self)
    @gpa = calculate_gpa_for(courses_with_grades) #Calculate GPA when pulling courses with grades for student.
    courses_with_grades
  end
  
  def gpa
    @gpa || 'GPA unavailable.'
  end
    
  def calculate_gpa_for(courses_with_grades) #Pulls grade + credit hours, then calculates GPA
    values = courses_with_grades.inject({:credit_points => 0, :credit_hours => 0}) do |values, course|
      values[:credit_points] += course.student_grade * course.credit_hours #course.grade should be generated in the declaration of @courses in course#index.
      values[:credit_hours] += course.credit_hours
      values
    end
    (values[:credit_points]/values[:credit_hours]).round(2)
  end
end