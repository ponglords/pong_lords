# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :match do
    before(:create) do |match|
      match.results << FactoryGirl.create(:result)
      match.results << FactoryGirl.create(:result, won: false)
    end
  end
end
