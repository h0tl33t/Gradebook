class Student < User 
  has_many :enrollments, foreign_key: 'student_id', dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course
  
  scope :with_grades_for, lambda {|course| joins(:enrollments).where(enrollments: {course: course}).select('users.*, enrollments.grade as grade')}
  
  def pull_courses_for(semester)
    self.enrolled_courses.for_semester(semester).with_grades_for(self)
  end
end