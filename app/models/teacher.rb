class Teacher < User
  has_many :courses, foreign_key: 'teacher_id', dependent: :destroy
  
  def teacher?
    true
  end
end