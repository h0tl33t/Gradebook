require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  setup do
    @enrollment = Enrollment.first
  end
  
  teardown do
    @enrollment = nil
  end
  
  test 'invalid without a student' do
    enrollment = FactoryGirl.build(:enrollment, student: nil)
    refute enrollment.valid?, 'Not validating presence of a student.'
  end
  
  test 'invalid without a course' do
    enrollment = FactoryGirl.build(:enrollment, course: nil)
    refute enrollment.valid?, 'Not validating presence of a course.'
  end
  
  test 'invalid without a grade' do
    enrollment = FactoryGirl.build(:enrollment, grade: nil)
    refute enrollment.valid?, 'Not validating presence of a grade.'
  end
  
  test 'belongs to a student' do
    enrollment = FactoryGirl.create(:enrollment)
    assert_respond_to(enrollment, :student, "Enrollment 'belongs_to student' association not configured correctly.")
  end
  
  test 'belongs to a course' do
    enrollment = FactoryGirl.create(:enrollment)
    assert_respond_to(enrollment, :course, "Enrollment 'belongs_to course' association not configured correctly.")
  end
  
  test 'a student cannot have more than one enrollment for a given course' do
    enrollment = FactoryGirl.create(:enrollment)
    assert_raise(ActiveRecord::RecordInvalid) {FactoryGirl.create(:enrollment, student: enrollment.student, course: enrollment.course)}
  end
  
  test 'float grade invalid if not between 0.0 and 4.0' do
    enrollment = FactoryGirl.build(:enrollment, grade: 4.2)
    refute enrollment.valid?, 'Not validating float grade range.'
  end
  
  test 'letter grade valid between 0.0 and 4.0' do
    enrollment = FactoryGirl.build(:enrollment, grade: '2.7')
    assert enrollment.valid?, 'Not accepting valid letter grades.'
  end
  
  test 'scope with courses for a given semester' do
    semester = @enrollment.course.semester
    assert_equal Enrollment.includes(:course).where(courses: {semester_id: semester.id}), Enrollment.with_courses_for_semester(semester), 
      'Not scoping courses for a given semester.'
  end
end
