require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    @course = Course.first
    @semester = @course.semester
    @teacher = @course.teacher
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil semester_course_path(@semester, assigns(:courses))
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create course" do
    assert_difference('Course.count') do
      post :create, course: { credit_hours: 2.0, description: 'Description', long_title: 'Long Title', name: 'Test Course', teacher_id: @teacher.id, semester_id: @semester.id}
    end

    assert_redirected_to semester_course_path(@semester.id, assigns(:course))
  end

  test "should show course" do
    get :show, id: @course
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @course
    assert_response :success
  end

  test "should update course" do
    patch :update, id: @course, course: { credit_hours: 4.0, description: @course.description, long_title: @course.long_title, name: @course.name }
    assert_redirected_to semester_course_path(@semester.id, assigns(:course))
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete :destroy, id: @course
    end

    assert_redirected_to courses_path
  end
end