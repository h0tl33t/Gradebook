class Enrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :course, counter_cache: true
  
  validates :grade, presence: true
  validates :student, presence: true
  validates :course, presence: true
  validate :enrollment_is_unique, on: :create
  validate :valid_grade_value
  
  before_save :convert_letter_grades
  after_save :trigger_avg_grade_calc_on_course
  
  scope :with_courses_for_semester, lambda {|semester| includes(:course).where(courses: {semester_id: semester.id})}
  
  def letter_grade
    GradeHelper.letter_grade_for(grade)
  end
  
  private
  def enrollment_is_unique
    unless Enrollment.where(student_id: student_id).where(course_id: course_id).empty?
      errors.add(:base, 'Students cannot enroll for the same course twice.')
    end
  end
  
  def valid_grade_value
    unless GradeHelper.valid?(grade)
      errors.add(:base, "Grades must be between 0.0 and 4.0 (if numeric).")
    end
  end
  
  def trigger_avg_grade_calc_on_course
    course.calculate_average_grade
    course.save
  end
  
  def convert_letter_grades
    if grade.present? and grade.class != Float
      self.grade = GradeHelper.numeric_grade_for(grade)
    end
  end
end
