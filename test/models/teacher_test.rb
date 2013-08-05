require 'test_helper' 

class TeacherTest < ActiveSupport::TestCase
  def setup
    @teacher = Student.first
    @semester = Semester.first
  end
  
  def teardown
    @teacher = nil
    @semester = nil
  end
  
  test 'User type populates with Teacher when saved' do
    teacher = FactoryGirl.create(:teacher)
    assert_equal 'Teacher', teacher.type
  end
  
  test 'can have many courses' do
    teacher = FactoryGirl.create(:teacher_with_courses)
    assert_respond_to(teacher, :courses, "Teacher 'has_many courses' association not configured correctly.")
  end
  
  test 'destroying teacher also destroys associated courses' do
    teacher = FactoryGirl.create(:teacher_with_courses)
    course = teacher.courses.first
    teacher.destroy
    refute Course.exists?(course), 'Not destroying associated courses when teacher is destroyed.'
  end
  
  test 'teacher is not an admin' do
    teacher = FactoryGirl.create(:teacher)
    refute teacher.admin?, 'Teacher passing as an admin.'
  end
  
  test 'teacher is not a student' do
    teacher = FactoryGirl.create(:teacher)
    refute teacher.student?, 'Teacher passing as a student.'
  end
  
  test 'teacher is a teacher' do
    teacher = FactoryGirl.create(:teacher)
    assert teacher.teacher?, 'Teacher not identified as a teacher.'
  end
end