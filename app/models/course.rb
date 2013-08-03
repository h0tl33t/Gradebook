class Course < ActiveRecord::Base
  belongs_to :semester, counter_cache: true
  belongs_to :teacher
  has_many :enrollments, dependent: :destroy
  has_many :enrolled_students, through: :enrollments, source: :student
  
  validates :name, presence: true, uniqueness: true, length: {maximum: 10}
  validates :long_title, presence: true, length: {maximum: 75}
  validates :description, presence: true
  validate :acceptable_value_for_credit_hours
  
  scope :for_semester, lambda {|semester| where(semester_id: semester)}
  scope :with_grades_for, lambda {|student| joins(:enrollments).where(enrollments: {student: student}).select('courses.*, enrollments.grade as student_grade')}
  
  def calculate_average_grade #Must be called via callback in EnrollmentsController, triggering from create, update, and destroy actions.
    self.average_grade = enrollments.average(:grade).round(2)
  end
  
  def average_letter_grade #Return average_grade in letter grade format.
    GradeHelper.letter_grade_for(average_grade)
  end
  
  def enrollment_count
    enrollments.size
  end
  
  private
  def acceptable_value_for_credit_hours
    unless (0.0..4.0).cover?(credit_hours) and [0.0,0.5].include?(credit_hours.modulo(1).round(1))
      errors.add(:base, "A course's credit hours must be between 0.0 and 4.0 and an increment of 0.5 hours.")
    end
  end
end
