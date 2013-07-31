class Teacher < User
  has_many :courses, foreign_key: 'teacher_id', dependent: :destroy
  
  def courses_for(semester)
    courses.for_semester(semester)
  end
end