require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build_stubbed :user }

  it 'should have a valid factory' do
    expect(subject).to be_valid
  end

  describe "#login=" do
  end
  describe "#login" do
  end

  describe ".find_or_create_from_omniauth" do
    let(:result) { subject.class.find_or_create_from_omniauth(auth) }
    let(:auth) { build :omniauth }

    context "matching auth found" do
      let!(:authorization) { create :authorization, uid: auth.uid, provider: auth.provider }

      it "should return the auth's user" do
        expect(result).to eq authorization.user
      end
    end

    context "no matching auth but matching user email" do
      let!(:user) { create :user, email: auth.info.email }

      it "should return user" do
        expect(result).to eq user
      end
    end

    context "no user found" do
      it "should create a new user with auth info" do
        expect { result }.to change(User, :count).by(1)
      end

      it "should create new auth" do
        expect { result }.to change(Authorization, :count).by(1)
      end
    end
  end

  describe ".find_from_omniauth" do
    let(:result) { subject.class.find_from_omniauth(auth) }
    let(:auth) { create :omniauth }

    context "matching auth found" do
      let!(:authorization) { create :authorization, uid: auth.uid, provider: auth.provider }

      it "should return the auth's user" do
        expect(result).to eq authorization.user
      end
    end

    context "no matching auth but matching user email" do
      let!(:user) { create :user, email: auth.info.email }

      it "should return user" do
        expect(result).to eq user
      end
    end

    context "no user found" do
      it "should return no user" do
        expect(result).to eq nil
      end
    end
  end

  describe ".create_from_omniauth" do
    let(:result) { subject.class.create_from_omniauth(auth) }
    let(:auth) { build :omniauth }

    it "should create a new user with auth info" do
      expect { result }.to change(User, :count).by(1)
    end

    it "should create new auth" do
      expect { result }.to change(Authorization, :count).by(1)
    end
  end

  describe "#find_invitation(id)" do
    subject { user }
    let(:user) { create :user }
    let(:friend) { create :user }
    let(:result) {  subject.find_invitation(friend) }

    context "invited friend" do
      let!(:invitation) { create :invitation, user: user, friend: friend }

      it "should return the invitation of that friend" do
        expect(result).to eq invitation
      end
    end

    context "didnt invite friend" do

      it "should return nil" do
        expect(result).to eq nil
      end
    end
  end
end
