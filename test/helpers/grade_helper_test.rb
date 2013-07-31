require 'test_helper'

class GradeHelperTest < ActionView::TestCase
  test 'grade_table returns hash when no value is passed' do
    assert_kind_of(Hash, GradeHelper.grade_table, 'Not returning hash when called without parameters.')
  end
  
  test 'letter_grades returns an array of all valid letter grade values' do
    assert_equal ['A','A-','B+','B','B-','C+','C','C-','D+','D','D-','F'], GradeHelper.letter_grades, 'Not returning array of valid letter grades.'
  end
    
  test 'grade_table returns letter grade when given a valid value' do
    assert_equal 'A', GradeHelper.grade_table(4.0), 'Not returning letter grade when given a valid value.'
  end
  
  test 'numeric_grade_for returns numeric grade when given a valid letter grade' do
    assert_equal 4.0, GradeHelper.numeric_grade_for('A'), 'Not returning numeric grade when given a valid letter grade.'
  end

  test 'letter_grade_for returns letter grade when given a known decimal grade value' do
    assert_equal 'C-', GradeHelper.letter_grade_for(1.7), 'Not returning correct letter grade when given a known decimal grade value.'
  end
    
  test 'valid grade value in decimal format' do
    assert GradeHelper.valid?(3.5), 'Not recognizing valid grades in decimal format.'
  end

  test 'invalid grade value in decimal format out of range' do
    refute GradeHelper.valid?(5), 'Not validating float-type grade ranges to be between 0.0 and 4.0.'
  end

  test 'validaty of grade value in letter format' do
    assert GradeHelper.valid?('B-'), 'Not recognizing valid letter grades.'
  end

  test 'validity of an unrecognized grade value' do
    refute GradeHelper.valid?('E'), 'Not validating letter grades as being between A to F.'
  end

  test 'correctly determines nearest decimal grade given a value between 0.0 and 4.0' do
    assert_equal 3.3, GradeHelper.nearest_decimal_grade(3.5), 'Not returning correct nearest decimal grade value.'
  end

  test 'letter_grade_for returns the nearest letter grade when given a decimal grade value between 0.0 and 4.0' do
    assert_equal 'B', GradeHelper.letter_grade_for(2.9), 'Not returning correct nearest letter grade.'
  end
end