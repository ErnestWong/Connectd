FactoryGirl.define do
  factory :omniauth, class: OmniAuth::AuthHash do
    sequence(:uid) { |n| "uid#{n}" }
    provider "facebook"
    sequence(:info) do |n|
      {
        nickname: "Nickname #{n}",
        first_name: "First#{n}",
        last_name: "Last#{n}",
        email: "omniauth#{n}@connectd.com",
      }
    end

    credentials do
      {
        token: 'totally-a-token'
      }
    end
  end
end
