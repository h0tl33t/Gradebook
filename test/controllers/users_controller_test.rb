require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @admin = Admin.first
    @student = Student.first
    @teacher = Teacher.first
  end

  test "should get index as admin" do
    sign_in(@admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end
  
  test "should redirect from index as student" do
    sign_in(@student)
    get :index
    assert_redirected_to root_path
  end
  
  test "should redirect from index as teacher" do
    sign_in(@teacher)
    get :index
    assert_redirected_to root_path
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { email: 'test_email@testing.com', first_name: 'New', last_name: 'User', password: 'testing123', password_confirmation: 'testing123'}
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    sign_in(@student)
    get :show, id: @student
    assert_response :success
  end

  test "should get edit" do
    sign_in(@teacher)
    get :edit, id: @teacher
    assert_response :success
  end

  test "should update teacher" do
    sign_in(@teacher)
    patch :update, id: @teacher, user: { email: 'new_teacher_email@test.com', first_name: @teacher.first_name, last_name: @teacher.last_name }
    assert_redirected_to user_path(assigns(:user))
  end
  
  test "should update admin" do
    sign_in(@admin)
    patch :update, id: @admin, user: { email: 'new_admin_email@test.com', first_name: @admin.first_name, last_name: @admin.last_name }
    assert_redirected_to user_path(assigns(:user))
  end
  
  test "should update student" do
    sign_in(@student)
    patch :update, id: @student, user: { email: 'new_student_email@test.com', first_name: @student.first_name, last_name: @student.last_name }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    test_user = DataGenerator::Core.new.user
    assert_difference('User.count', -1) do
      delete :destroy, id: test_user.id
    end

    assert_redirected_to root_path
  end
end