require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    @student = Student.first
    @semester = Semester.first
  end
  
  def teardown
    @student = nil
    @semester = nil
  end
  
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

  test 'courses_for as a Student returns all enrolled_courses for a given semester' do
    student = FactoryGirl.create(:student_with_enrollments)
    courses = student.courses_for(@semester)
    assert_equal Course.for_semester(@semester).joins(:enrollments).where(enrollments: {student: student}).to_a, student.courses_for(@semester),
      'Not pulling all enrolled courses for a given semester.'
  end
  
  test 'courses returned from courses_for allow the student to view grade by course.student_grade' do
    student = FactoryGirl.create(:student_with_enrollments)
    #semester = FactoryGirl.create(:semester)
    courses = student.courses_for(@semester)
    assert_respond_to(courses.first, :student_grade, 'Student grade is not accessible from courses returned from courses_for.')
  end
  
  test 'can retrieve enrollments with course data for a given semester' do
    assert_equal Enrollment.where(student: @student).includes(:course).where(courses: {semester_id: @semester.id}).to_a, @student.enrollments_for(@semester),
      'Not correctly pulling enrollments with course data for a given semester.'
  end
  
  test 'student is not an admin' do
    student = FactoryGirl.create(:student)
    refute student.admin?, 'Student passing as an admin.'
  end
  
  test 'student is not a teacher' do
    student = FactoryGirl.create(:student)
    refute student.teacher?, 'Student passing as a teacher.'
  end
  
  test 'student is a student' do
    student = FactoryGirl.create(:student)
    assert student.student?, 'Student not identified as a student.'
  end
  
  test 'responds to gpa' do
    student = FactoryGirl.create(:student)
    assert_respond_to(student, :gpa, 'No student.gpa method was found.')
  end

  test 'can retrieve gpa from given courses' do
    student = FactoryGirl.create(:student)

    course1 = FactoryGirl.create(:course, semester: @semester, credit_hours: 3)
    course2 = FactoryGirl.create(:course, semester: @semester, credit_hours: 4) 
    course3 = FactoryGirl.create(:course, semester: @semester, credit_hours: 3)
    course4 = FactoryGirl.create(:course, semester: @semester, credit_hours: 2.5) 
    course5 = FactoryGirl.create(:course, semester: @semester, credit_hours: 4) #16.5 total credit hours for semester

    enrollment1 = FactoryGirl.create(:enrollment, course: course1, student: student, grade: 2.3) #6.9 credit points
    enrollment2 = FactoryGirl.create(:enrollment, course: course2, student: student, grade: 4.0) #16 credit points
    enrollment3 = FactoryGirl.create(:enrollment, course: course3, student: student, grade: 1.7) #5.1 credit points
    enrollment4 = FactoryGirl.create(:enrollment, course: course4, student: student, grade: 3.0) #7.5 credit points
    enrollment5 = FactoryGirl.create(:enrollment, course: course5, student: student, grade: 3.7) #14.8 credit points
    
    #enrollments = Enrollment.includes(:course).where(courses: {semester_id: @semester.id})
    enrollments = [enrollment1, enrollment2, enrollment3, enrollment4, enrollment5]
    
    #GPA should be credit points (50.3) divided by total credit hours (16.5) with the result rounded to two decimal places => 3.05
    assert_equal 3.05, student.calculate_gpa_with(enrollments), 'Not correctly calculating GPA from given courses.'
  end

  test 'GPA is set during courses_for method call' do
    student = FactoryGirl.create(:student)
    semester = FactoryGirl.create(:semester, start_date: 30.days.ago, end_date: 10.days.ago)

    course1 = FactoryGirl.create(:course, semester: semester, credit_hours: 3)
    course2 = FactoryGirl.create(:course, semester: semester, credit_hours: 4) 
    course3 = FactoryGirl.create(:course, semester: semester, credit_hours: 3)
    course4 = FactoryGirl.create(:course, semester: semester, credit_hours: 2.5) 
    course5 = FactoryGirl.create(:course, semester: semester, credit_hours: 4) #16.5 total credit hours for semester

    enrollment1 = FactoryGirl.create(:enrollment, course: course1, student: student, grade: 2.3) #6.9 credit points
    enrollment2 = FactoryGirl.create(:enrollment, course: course2, student: student, grade: 4.0) #16 credit points
    enrollment3 = FactoryGirl.create(:enrollment, course: course3, student: student, grade: 1.7) #5.1 credit points
    enrollment4 = FactoryGirl.create(:enrollment, course: course4, student: student, grade: 3.0) #7.5 credit points
    enrollment5 = FactoryGirl.create(:enrollment, course: course5, student: student, grade: 3.7) #14.8 credit points

    student.courses_for(semester)

    #GPA should be credit points (50.3) divided by total credit hours (16.5) with the result rounded to two decimal places => 3.05
    assert_equal 3.05, student.gpa, 'Not calculating and setting GPA during courses_for method call.'
  end
end