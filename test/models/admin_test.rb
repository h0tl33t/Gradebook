require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  test 'User type populates with Admin when saved' do
    admin = FactoryGirl.create(:admin)
    assert_equal 'Admin', admin.type
  end
end