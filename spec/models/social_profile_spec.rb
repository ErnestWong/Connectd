require 'rails_helper'

RSpec.describe SocialProfile, type: :model do
  subject { build_stubbed :social_profile }

  it 'should have a valid factory' do
    expect(subject).to be_valid
  end
end
