require 'rails_helper'

RSpec.describe Invitation, type: :model do
  subject { build :invitation }

  it 'should have a valid factory' do
    expect(subject).to be_valid
  end

  describe "#friend_exists?" do
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

  describe "#invitation_exists?" do
    subject { build :invitation, user: user, friend: friend }
    let(:user) { create :user }
    let(:friend) { create :user }

    context "user already invited friend" do
      let!(:existing_invitation) { create :invitation, user: user, friend: friend }

      it "should not be valid" do
        expect(subject).to_not be_valid
      end
    end

    context "user hasnt invited friend" do
      it "should be valid" do
        expect(subject).to be_valid
      end
    end
  end

  describe "#invite_self?" do
    subject { build :invitation, user: user, friend: user }
    let(:user) { create :user }

    context "user inviting self" do
      it "should not be valid" do
        expect(subject).to_not be_valid
      end
    end
  end
end
