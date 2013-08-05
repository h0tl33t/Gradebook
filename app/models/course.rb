class Course < ActiveRecord::Base
  belongs_to :semester, counter_cache: true
  belongs_to :teacher
  has_many :enrollments, dependent: :destroy
  has_many :enrolled_students, through: :enrollments, source: :student
  
  validates :name, presence: true, uniqueness: true, length: {maximum: 10}
  validates :long_title, presence: true, length: {maximum: 75}
  validates :description, presence: true
  validate :acceptable_value_for_credit_hours
  
  default_scope -> {order(:name)}
  scope :for_semester, lambda {|semester| where(semester_id: semester)}
  scope :enrollable, lambda {joins(:semester).where('semesters.end_date >= ?', Date.today)}
  scope :not_enrollable_for, lambda {|student| joins(:enrollments).where(enrollments: {student_id: student.id})}
  scope :without_enrollments, lambda {where(enrollments_count: 0)}

  def calculate_average_grade #Must be called via callback in EnrollmentsController, triggering from create, update, and destroy actions.
    self.average_grade = enrollments.average(:grade).round(2)
  end
  
  def average_letter_grade #Return average_grade in letter grade format.
    GradeHelper.letter_grade_for(average_grade)
  end
  
  def enrollment_count #Alias for counter cache on enrollments.
    enrollments.size
  end
  
  def enrollable_for?(student)
    !enrolled_students.include?(student) #Return true if course doesn't have a given student already enrolled.  False if a given student has an enrollment.
  end
  
  private
  def acceptable_value_for_credit_hours
    unless (0.0..4.0).cover?(credit_hours) and [0.0,0.5].include?(credit_hours.modulo(1).round(1))
      errors.add(:base, "A course's credit hours must be between 0.0 and 4.0 and an increment of 0.5 hours.")
    end
  end
end
