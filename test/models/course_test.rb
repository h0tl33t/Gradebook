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
  
  test 'name is invalid if over 10 characters long' do
    course = FactoryGirl.build(:course, name: "#{''.ljust(11,'i')}")
    refute course.valid?, 'Not validating length of name.'
  end
  
  test 'long title is invalid if over 75 characters long' do
    course = FactoryGirl.build(:course, long_title: "#{''.ljust(76,'i')}")
    refute course.valid?, 'Not validating length of long_title.'
  end
  
  test 'credit hours invalid unless between 0.5 and 4.0' do
    course = FactoryGirl.build(:course, credit_hours: 5.0)
    refute course.valid?, 'Not validating credit hours against valid range (0.5 to 4.0).'
  end
  
  test 'credit hours invalid unless in an increment of 0.5 hours' do
    course = FactoryGirl.build(:course, credit_hours: 1.7)
    refute course.valid?, 'Not validating credit hour values in increments of 0.5.'
  end
  
  test 'uniqueness of course name' do
    course = FactoryGirl.create(:course, name: 'Math 101')
    assert_raise(ActiveRecord::RecordInvalid) {FactoryGirl.create(:course, name: 'Math 101')}
  end
  
  test 'valid with all attributes' do
    course = FactoryGirl.build(:course)
    assert course.valid?, 'Not accepting course with all valid attributes.'
  end
  
  test 'belongs to semester' do
    course = FactoryGirl.create(:course)
    assert_respond_to(course, :semester, "Course 'belongs_to semester' association not configured correctly.")
  end
  
  test 'can scope by semester' do
    semester_list = FactoryGirl.create_list(:semester_with_courses, 2) #Generate two semesters, each with a set of courses.
    assert_equal semester_list.first.courses, Course.for_semester(semester_list.first), 'For semester scope is not pulling correct courses for a given semester.'
  end
  
  test 'has many enrollments' do
    course = FactoryGirl.create(:course_with_enrollments)
    assert_respond_to(course, :enrollments, "Course 'has_many enrollments' association not configured correctly.")
  end
  
  test 'has many enrolled students through enrollments' do
    course = FactoryGirl.create(:course_with_enrollments)
    assert_respond_to(course, :enrolled_students, "Course 'has_many enrolled students through enrollment' association not configured correctly.")
  end
  
  test 'has counter cache on associated enrollments' do
    course = FactoryGirl.create(:course_with_enrollments)
    assert_respond_to(course, :enrollments_count, 'Course counter cache on association enrollments not configured correctly.')
  end
  
  test 'belongs to a teacher' do
    course = FactoryGirl.create(:course)
    assert_respond_to(course, :teacher, "Course 'belongs_to teacher' association not configured correctly.")
  end
  
  test 'destroying course also destroys associated enrollments' do
    course = FactoryGirl.create(:course_with_enrollments)
    enrollment = course.enrollments.first
    course.destroy
    refute Enrollment.exists?(enrollment), 'Not destroying associated enrollments.'
  end
end
