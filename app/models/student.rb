class Student < User 
  has_many :enrollments, foreign_key: 'student_id', dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course
end