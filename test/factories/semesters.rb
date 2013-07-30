# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :semester do
    name 'Fall 2013'
    start_date "2013-09-01"
    end_date "2013-12-31"
  end
end
