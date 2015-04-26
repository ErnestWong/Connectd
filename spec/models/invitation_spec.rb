require 'rails_helper'

RSpec.describe Invitation, type: :model do
  subject { create :invitation }

  it 'should have a valid factory' do
    expect(subject).to be_valid
  end

  describe "#friend_exists" do
    subject { invitation }
    let(:user2) { create :user }

    context "friend is an existing user" do
      let(:invitation) { build :invitation }

      it "should be valid" do
        expect(subject).to be_valid
      end
    end

    context "friend is not an existing user" do
      let(:invitation) { build :invitation, friend_id: 1000 }

      it "should not be valid" do
        expect(subject).to_not be_valid
      end
    end
  end
end
