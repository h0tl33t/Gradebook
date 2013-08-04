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
  
  def enrollments_for(semester)
    enrollment_list = enrollments.with_courses_for_semester(semester)
    self.gpa = calculate_gpa_with(enrollment_list)
    #GPA only being seen at the index view, where enrollments_for generates the data.  Reduce DB queries and calculate and store the GPA in paraellel.
    enrollment_list
  end
  
  def gpa
    @gpa #|| 'GPA unavailable.'
  end
  
  def calculate_gpa_with(enrollment_list)
    values = enrollment_list.inject({credit_points: 0, credit_hours: 0}) do |values, enrollment|
      values[:credit_points] += enrollment.grade * enrollment.course.credit_hours
      values[:credit_hours] += enrollment.course.credit_hours
      values
    end
    gpa = (values[:credit_points]/values[:credit_hours]).round(2)
    #binding.pry
  end
  
  def student?
    true
  end
end