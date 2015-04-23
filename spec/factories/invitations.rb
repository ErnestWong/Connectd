FactoryGirl.define do
  factory :invitation do
    association :user
    association :friend, factory: :user
  end
end
