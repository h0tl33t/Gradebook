require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  test 'invalid without a name' do
    course = FactoryGirl.build(:course, name: nil)
    refute course.valid?, 'Not validating presence of name.'
  end
  
  test 'invalid without a long title' do
    course = FactoryGirl.build(:course, long_title: nil)
    refute course.valid?, 'Not validating presence of long title.'
  end
  
  test 'invalid without a description' do
    course = FactoryGirl.build(:course, description: nil)
    refute course.valid?, 'Not validating presence of long title.'
  end
  
  test 'credit hours invalid unless between 0.0 and 4.0 in an increment of 0.5 hours' do
    course = FactoryGirl.build(:course, credit_hours: 1.7)
    refute course.valid?, 'Not validating acceptable credit hour values.'
  end
  
  test 'valid with all attributes' do
    course = FactoryGirl.build(:course)
    assert course.valid?, 'Not accepting course with all valid attributes.'
  end
  
  test 'belongs to course' do
    course = FactoryGirl.create(:course_with_semester)
    assert_respond_to(course, :semester, "Course 'belongs_to Semester' association not configured.")
  end
  
  test 'can scope by semester' do
    semester_list = FactoryGirl.create_list(:semester_with_courses, 2) #Generate two semesters, each with a set of courses.
    assert_equal semester_list.first.courses, Course.for_semester(semester_list.first), 'For semester scope is not pulling correct courses for a given semester.'
  end
end
