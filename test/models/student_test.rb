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
  
  test 'destroying student also destroys associated enrollments' do
    student = FactoryGirl.create(:student_with_enrollments)
    enrollment = student.enrollments.first
    student.destroy
    refute Enrollment.exists?(enrollment), 'Not destroying associated enrollments when destroying student.'
  end
  
  test 'pull_courses_for as a Student returns all enrolled_courses for a given semester' do
    student = FactoryGirl.create(:student_with_enrollments)
    semester = FactoryGirl.create(:semester)
    assert_equal Course.for_semester(semester).joins(:enrollments).where(enrollments: {student: student}).to_a, student.pull_courses_for(semester),
      'Not pulling all enrolled courses for a given semester.'
  end
  
  test 'courses returned from pull_courses_for allow the student to view grade by course.student_grade' do
    student = FactoryGirl.create(:student_with_enrollments)
    semester = FactoryGirl.create(:semester)
    courses = student.courses_for(semester)
    assert_respond_to(courses.first, :student_grade, 'Student grade is not accessible from courses returned from courses_for.')
  end
  
  test 'courses_for as a Student returns all enrolled_courses for a given semester' do
    student = FactoryGirl.create(:student_with_enrollments)
    semester = FactoryGirl.create(:semester)
    courses = student.courses_for(semester)
    assert_equal Course.for_semester(semester).joins(:enrollments).where(enrollments: {student: student}).to_a, student.courses_for(semester),
      'Not pulling all enrolled courses for a given semester.'
  end
end