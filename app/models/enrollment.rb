class Enrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :course
  
  validates :grade, presence: true
  validates :student, presence: true
  validates :course, presence: true
  validate :enrollment_is_unique
  
  def enrollment_is_unique
    unless Enrollment.where(student_id: self.student_id).where(course_id: self.course_id).empty?
      errors.add(:base, 'Students cannot enroll for the same course twice.')
    end
  end
end
