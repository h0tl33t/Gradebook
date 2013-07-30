require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test 'User type populates with Student when saved' do
    student = FactoryGirl.create(:student)
    assert_equal 'Student', student.type
  end
  
  test 'can have many enrollments' do
    student = FactoryGirl.create(:student_with_enrollments)
    assert_respond_to(student, :enrollments, "Student 'has_many enrollments' association not configured correctly.")
  end
  
  test 'has many enrolled courses through enrollments' do
    student = FactoryGirl.create(:student_with_enrollments)
    assert_respond_to(student, :enrolled_courses, "Student 'has_many enrolled_courses through enrollments' association not configured correctly.")
  end
end