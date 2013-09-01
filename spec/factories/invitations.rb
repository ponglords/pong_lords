# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    email "test@example.com"
    first_name "First"
    last_name "Last"
  end
end
