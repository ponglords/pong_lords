# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :result do
    won true
    association :player, factory: :player
  end
end
