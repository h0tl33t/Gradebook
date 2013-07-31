require 'test_helper'

class SemesterTest < ActiveSupport::TestCase
  test 'semester invalid without a name' do
    semester = FactoryGirl.build(:semester, name: nil)
    refute semester.valid?, 'Not validating presence of name.'
  end
  
  test 'semester invalid without a start date' do
    semester = FactoryGirl.build(:semester, start_date: nil)
    assert_raises(ArgumentError) {semester.save} #Due to overlap validations, just looking for a bad range ArgumentError.
  end
  
  test 'semester invalid without an end date' do
    semester = FactoryGirl.build(:semester, end_date: nil)
    assert_raises(ArgumentError) {semester.save} #Due to overlap validations, just looking for a bad range ArgumentError.
  end
  
  test 'semester invalid if it starts during another semester' do
    semester1 = FactoryGirl.create(:semester, start_date: 20.days.ago, end_date: 20.days.from_now)
    semester2 = FactoryGirl.build(:semester, start_date: 10.days.ago, end_date: 25.days.from_now)
    refute semester2.valid?, "Not validating start date overlapping an existing semester's range."
  end
  
  test 'semester invalid if it ends during another semester' do
    semester2 = FactoryGirl.build(:semester, start_date: 20.days.ago, end_date: 20.days.from_now)
    semester1 = FactoryGirl.create(:semester, start_date: 25.days.ago, end_date: 10.days.from_now)
    refute semester2.valid?, "Not validating end date overlapping an existing semester's range."
  end
  
  test 'can have many courses' do
    semester = FactoryGirl.create(:semester_with_courses)
    assert_respond_to(semester, :courses, "Semester 'has_many courses' association not configured correctly.")
  end
  
  test 'has counter_cache on associated courses' do
    semester = FactoryGirl.create(:semester_with_courses)
    assert_respond_to(semester, :courses_count, 'Semester counter_cache on courses not correctly configured.')
  end
  
  test 'destroying semester also destroys related courses' do
    semester = FactoryGirl.create(:semester_with_courses)
    course = semester.courses.first
    semester.destroy
    refute Course.exists?(course), 'Not destroying associated courses when semester is destroyed.'
  end
end
