FactoryGirl.define do
  factory :social_profile do
    association :user

    factory :facebook, class: FacebookProfile, parent: :social_profile do
      type "facebook"
    end

    factory :instagram, class: InstagramProfile, parent: :social_profile do
      type "instagram"
    end

    factory :linkedin, class: LinkedinProfile, parent: :social_profile do
      type "linkedin"
    end

    factory :twitter, class: TwitterProfile, parent: :social_profile do
      type "twitter"
    end
  end
end
