require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  test 'User type populates with Admin when saved' do
    admin = FactoryGirl.create(:admin)
    assert_equal 'Admin', admin.type
  end
  
  test 'admin is not a student' do
    admin = FactoryGirl.create(:admin)
    refute admin.student?, 'Admin passing as a student.'
  end
  
  test 'admin is not a teacher' do
    admin = FactoryGirl.create(:admin)
    refute admin.teacher?, 'Admin passing as a teacher.'
  end
  
  test 'admin is an admin' do
    admin = FactoryGirl.create(:admin)
    assert admin.admin?, 'Admin not identifed as an admin.'
  end
end