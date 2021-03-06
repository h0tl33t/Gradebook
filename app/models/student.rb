class Student < User
  attr_writer :gpa
  
  has_many :enrollments, foreign_key: 'student_id', dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course
  
  def enrollments_for(semester)
    enrollment_list = enrollments.with_courses_for_semester(semester)
    calculate_gpa_with(enrollment_list)
    #GPA only being seen on enrollments#index view, where enrollments_for generates the data.  Reduce DB queries and calculate and store the GPA in paraellel.
    enrollment_list
  end
  
  def gpa
    @gpa || 'GPA unavailable.'
  end
  
  def calculate_gpa_with(enrollment_list)
    values = enrollment_list.inject({credit_points: 0, credit_hours: 0}) do |values, enrollment|
      values[:credit_points] += enrollment.grade * enrollment.course.credit_hours
      values[:credit_hours] += enrollment.course.credit_hours
      values
    end
    self.gpa = (values[:credit_points]/values[:credit_hours]).round(2) unless values[:credit_hours] == 0
  end
  
  def student?
    true
  end
end