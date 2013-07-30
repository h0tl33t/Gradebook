# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    name "MATH 101"
    long_title "An Introduction to Mathematics"
    description "10:00 to 10:50AM, M/W/F, 310 Bouke"
    credit_hours 3.0
  end
end
