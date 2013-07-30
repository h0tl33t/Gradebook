require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
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
end
