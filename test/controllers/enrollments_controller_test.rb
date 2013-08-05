require 'test_helper'

class EnrollmentsControllerTest < ActionController::TestCase
  
  setup do
    @course = Course.first
    @student = Student.first
    @teacher = Teacher.first
    @admin = Admin.first
    @enrollment = Enrollment.first
    @current_semester = Semester.current
  end

  test "should get index as student" do
    sign_in(@student)
    get :index, semester_id: @current_semester.id
    assert_response :success
  end
  
  test "should redirect as an admin" do
    sign_in(@admin)
    get :index, semester_id: @current_semester.id
    assert_redirected_to semester_courses_path(@current_semester.id)
  end
  
  test "should redirect as a teacher" do
    sign_in(@teacher)
    get :index, semester_id: @current_semester.id
    assert_redirected_to semester_courses_path(@current_semester.id)
  end

  test "should destroy enrollment for student" do
    sign_in(@student)
    enrollment_to_destroy = DataGenerator::Core.new.enrollment(students: @student, courses: @course)
    assert_difference('Enrollment.count', -1) do
      delete :destroy, semester_id: @current_semester.id, id: @enrollment
    end

    assert_redirected_to semester_enrollments_path(@current_semester.id)
  end
end