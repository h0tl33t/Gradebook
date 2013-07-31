# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    sequence(:name, 101) {|i| "Math #{i}"}
    long_title "An Introduction to Mathematics"
    description "10:00 to 10:50AM, M/W/F, 310 Bouke"
    credit_hours 3.0
    teacher
    semester_id 1
      
    factory :course_with_enrollments do
      ignore do
        enrollments_count 10
      end
      
      after(:create) do |course, evaluator|
        FactoryGirl.create_list(:enrollment, evaluator.enrollments_count, course: course)
      end
    end
  end
end