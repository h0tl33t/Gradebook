require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test 'User type populates with Student when saved' do
    student = FactoryGirl.create(:student)
    assert_equal 'Student', student.type
  end
end