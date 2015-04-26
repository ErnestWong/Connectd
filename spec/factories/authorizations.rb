FactoryGirl.define do
  factory :authorization do
    sequence(:uid) { |n| "uid#{n}" }
    name "Joe Smith"
    provider "facebook"
    association :user
    association :data, factory: :omniauth
  end
end
