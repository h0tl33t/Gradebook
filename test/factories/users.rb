# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name 'Bobby'
    last_name 'Brokaw'
    email 'Bobby.Brokaw@test.com'.downcase
    password 'secret'
    password_confirmation {|user| user.password}
  end
  
  factory :admin, {parent: :user, class: 'Admin'} do
    #Admin-specific associations.
  end
  
  factory :student, {parent: :user, class: 'Student'} do
    #Student-specific associations.
  end
  
  factory :teacher, {parent: :user, class: 'Teacher'} do
    #Teacher-specific associations.
  end
end
