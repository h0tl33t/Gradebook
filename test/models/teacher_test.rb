require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  test 'User type populates with Teacher when saved' do
    teacher = FactoryGirl.create(:teacher)
    assert_equal 'Teacher', teacher.type
  end
  
  test 'can have many courses' do
    teacher = FactoryGirl.create(:teacher_with_courses)
    assert_respond_to(teacher, :courses, "Teacher 'has_many courses' association not configured correctly.")
  end
end