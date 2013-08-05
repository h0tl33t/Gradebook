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
    #Current Semester is seeded to test DB already with a duration of 90 days.  Any short-term semester should fail the overlaps validation.
    current_semester = Semester.current
    semester = FactoryGirl.build(:semester, start_date: Date.today, end_date: (current_semester.end_date + 1.day))
    refute semester.valid?, "Not validating start date overlapping an existing semester's range."
  end
  
  test 'semester invalid if it ends during another semester' do
    #Current Semester is seeded to test DB already with a duration of 90 days.  Any short-term semester should fail the overlaps validation.
    current_semester = Semester.current
    semester = FactoryGirl.build(:semester, start_date: (current_semester.start_date - 1.day), end_date: Date.today)
    refute semester.valid?, "Not validating end date overlapping an existing semester's range."
  end
  
  test 'semester invalid if it is enveloped by another semester' do
    #Current Semester is seeded to test DB already with a duration of 90 days.  Any short-term semester should fail the overlaps validation.
    semester = FactoryGirl.build(:semester, start_date: 5.days.ago, end_date: 5.days.from_now)
    refute semester.valid?, "Not validating new courses that are enveloped completely by existing semesters."
  end
  
  test 'can have many courses' do
    semester = Semester.first
    assert_respond_to(semester, :courses, "Semester 'has_many courses' association not configured correctly.")
  end
  
  test 'has counter_cache on associated courses' do
    semester = Semester.first
    assert_respond_to(semester, :courses_count, 'Semester counter_cache on courses not correctly configured.')
  end
  
  test 'destroying semester also destroys related courses' do
    semester = Semester.first
    course = semester.courses.first
    semester.destroy
    refute Course.exists?(course), 'Not destroying associated courses when semester is destroyed.'
  end
  
  test 'current scope returns semester that overlaps Date.today' do
    current_semester = Semester.current
    assert (current_semester.start_date..current_semester.end_date).cover?(Date.today), 'Current scope not pulling semester covering Date.today.'
  end
  
  test 'invalid if the end date is before the start date' do
    semester = FactoryGirl.build(:semester, start_date: Date.today, end_date: 10.days.ago)
    refute semester.valid?, 'Allowing semesters to end before they start.'
  end
  
  test 'ability to determine whether a semester is over' do
    semester = FactoryGirl.build(:semester, start_date: 1.year.ago, end_date: 6.months.ago)
    assert semester.over?, 'Not correctly identifying semesters that have ended.'
  end
end
