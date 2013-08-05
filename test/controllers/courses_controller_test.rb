require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  include SessionsHelper
  setup do
    @course = Course.first
    @semester = @course.semester
    @teacher = @course.teacher
    @student = @course.enrollments.first.student
    @admin = Admin.first
    @current_semester = Semester.current
  end

  test "should get index for student" do
    sign_in(@student)
    get :index, semester_id: @semester.id
    assert_response :success
    assert_not_nil assigns(:courses)
  end
  
  test "should get index for admin" do
    sign_in(@admin)
    get :index, semester_id: @semester.id
    assert_response :success
    assert_not_nil assigns(:courses)
  end
  
  test "should get index for teacher" do
    sign_in(@teacher)
    get :index, semester_id: @semester.id
    assert_response :success
    assert_not_nil assigns(:courses)
  end

  test "should redirect from new for student" do
    sign_in(@student)
    get :new, semester_id: 1
    assert_redirected_to controller: :courses, action: :index
  end
  
  test "should redirect from new for admin" do
    sign_in(@admin)
    get :new, semester_id: @current_semester.id
    assert_redirected_to controller: :courses, action: :index
  end
  
  test "should get new for teacher" do
    sign_in(@teacher)
    get :new, semester_id: @current_semester.id
    assert_response :success
  end

  test "should show course for teacher" do
    sign_in(@teacher)
    get :show, semester_id: @semester.id, id: @course.id
    assert_response :success
  end
  
  test "should show course for admin" do
    sign_in(@admin)
    get :show, semester_id: @semester.id, id: @course.id
    assert_response :success
  end
  
  test "should redirect from show course for student" do
    sign_in(@student)
    get :show, semester_id: @semester.id, id: @course.id
    assert_redirected_to semester_courses_path(@semester.id)
  end
  
  test "should get edit for teacher" do
    sign_in(@teacher)
    get :edit, semester_id: @semester.id, id: @course.id
    assert_response :success
  end
  
  test "should destroy course as teacher" do
    sign_in(@teacher)
    assert_difference('Course.count', -1) do
      delete :destroy, semester_id: @semester.id, id: @course.id
    end

    assert_redirected_to semester_courses_path(@semester.id)
  end
end