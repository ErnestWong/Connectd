FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.com" }
    sequence(:username) { |i| "username#{i}" }
    password "password"
    password_confirmation "password"
    first_name "Foo"
    last_name "Bar"
  end
end
