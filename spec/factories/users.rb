FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.com" }
    sequence(:username) { |i| "username#{i}" }
    password "password"
  end
end
