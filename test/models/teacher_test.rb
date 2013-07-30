require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  test 'User type populates with Teacher when saved' do
    teacher = FactoryGirl.create(:teacher)
    assert_equal 'Teacher', teacher.type
  end
end