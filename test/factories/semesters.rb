# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :semester do
    name 'Fall 2013'
    sequence(:start_date) {|i| "2013-07-#{i}"}
    sequence(:end_date) {|i| "2013-07-#{i}"}
    
    factory :semester_with_courses do
      ignore do
        courses_count 10
      end
      
      after(:create) do |semester, evaluator|
        FactoryGirl.create_list(:course, evaluator.courses_count, semester: semester)
      end
    end
  end
end
