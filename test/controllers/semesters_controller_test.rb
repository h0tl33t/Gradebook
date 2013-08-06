require 'test_helper'

class SemestersControllerTest < ActionController::TestCase
  include SessionsHelper
  
  setup do
    @semester = Semester.first
    @admin = Admin.first
    sign_in(@admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:semesters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create semester" do
    new_semester = DataGenerator::Core.new.semester(action: :new)
    assert_difference('Semester.count') do
      post :create, semester: { name: new_semester.name, start_date: new_semester.start_date, end_date: new_semester.end_date, }
    end

    assert_redirected_to semesters_path
  end

  test "should redirect from show semester" do
    get :show, id: @semester
    assert_redirected_to semesters_path
  end

  test "should get edit" do
    get :edit, id: @semester
    assert_response :success
  end

  test "should update semester" do
    patch :update, id: @semester, semester: { end_date: @semester.end_date, name: @semester.name, start_date: @semester.start_date }
    assert response: :success
  end

  test "should destroy semester" do
    assert_difference('Semester.count', -1) do
      delete :destroy, id: @semester
    end

    assert_redirected_to semesters_path
  end
end