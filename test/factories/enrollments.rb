# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :enrollment do
    student
    course
    grade GradeHelper.nearest_decimal_grade(Random.new.rand(0.0..4.0))
  end
end
