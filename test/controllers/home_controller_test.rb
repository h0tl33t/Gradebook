require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert response: :sucess
  end
end
