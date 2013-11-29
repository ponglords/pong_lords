# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    sequence(:email) { |n| "factory-player-#{n}@test.com" }
    password "password"
  end
end
