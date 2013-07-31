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
    assert_respond_to(course, :enrollment_count, 'Course counter cache on association enrollments not configured correctly.')
  end
  
  test 'returns counter cache value for enrollment count' do
    course = FactoryGirl.create(:course_with_enrollments)
    assert_equal course.enrollments.size, course.enrollment_count, 'Not returning correct enrollment count.'
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
  
  test 'ability to display all enrolled students with their grades as student.grade' do
    course = FactoryGirl.create(:course_with_enrollments)
    assert_equal course.enrolled_students.joins(:enrollments).select('users.*, enrollments.grade as grade').to_a,
      course.enrolled_students.with_grades_for(course),
      'Not correctly pulling students with grades for a given course.'
  end
  
  test 'calculates correct average grade' do
    course = FactoryGirl.create(:course)
    enrollment1 = FactoryGirl.create(:enrollment, course: course, grade: 3.0)
    enrollment2 = FactoryGirl.create(:enrollment, course: course, grade: 2.3)
    enrollment3 = FactoryGirl.create(:enrollment, course: course, grade: 3.7)
    enrollment4 = FactoryGirl.create(:enrollment, course: course, grade: 4.0)
    assert_equal 3.25, course.calculate_average_grade, 'Not correctly calculating average grade.'
  end
  
  test 'average_grade holds correct value' do    
    course = FactoryGirl.create(:course)
    enrollment1 = FactoryGirl.create(:enrollment, course: course, grade: 1.7)
    enrollment2 = FactoryGirl.create(:enrollment, course: course, grade: 2.3)
    enrollment3 = FactoryGirl.create(:enrollment, course: course, grade: 3.3)
    enrollment4 = FactoryGirl.create(:enrollment, course: course, grade: 4.0)
    course.calculate_average_grade
    assert_equal 2.83, course.average_grade, 'Average Grade not returning correct value.'
  end

  test 'can retrieve average grade as a letter grade' do
    course = FactoryGirl.create(:course_with_enrollments)
    avg_grade = course.average_letter_grade
    assert_kind_of(String, avg_grade, 'Average letter grade not returning grade as a string.')
  end
end
