# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:first_name) {|i| "User#{i}"}
    sequence(:last_name) {|i| "Test#{i}"}
    sequence(:email) {|i| "user#{i}@test.com".downcase}
    password 'secret'
    password_confirmation {|user| user.password}
  end
  
  factory :admin, {parent: :user, class: 'Admin'} do
    #Admin-specific associations.
  end
  
  factory :student, {parent: :user, class: 'Student'} do
    factory :student_with_enrollments do
      ignore do
        enrollments_count 5
      end
      
      after(:create) do |student, evaluator|
        FactoryGirl.create_list(:enrollment, evaluator.enrollments_count, student: student)
      end
    end
  end
  
  factory :teacher, {parent: :user, class: 'Teacher'} do
    factory :teacher_with_courses do
      ignore do
        courses_count 10
      end
      
      after(:create) do |teacher, evaluator|
        FactoryGirl.create_list(:course, evaluator.courses_count, teacher: teacher)
      end
    end
  end
end
