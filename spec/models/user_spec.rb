require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build_stubbed :user }

  it 'should have a valid factory' do
    expect(subject).to be_valid
  end

  describe "downcase_username" do
    subject { build_stubbed :user, username: username }
    let(:username) { "uSerName1" }

    it "should return lowercase" do
      subject.valid?
      expect(subject.username).to eq "username1"
    end
  end

  describe "username" do
    subject { build_stubbed :user, username: username }

    context "existing username case insensitive" do
      before { create :user, username: "uSernAme1" }
      let(:username) { "username1" }

      it "should not be valid" do
        expect(subject).to_not be_valid
      end
    end

    context "too long" do
      let(:username) { "1234567890username1234567890" }
      it "should not be valid" do
        expect(subject).to_not be_valid
      end
    end

    context "too short" do
      let(:username) { "ds" }
      it "should not be valid" do
        expect(subject).to_not be_valid
      end
    end

    context "when blank" do
      let(:username) { "" }
      it "should not be valid" do
        expect(subject).to_not be_valid
      end
    end

    context "invalid characters" do
      let(:username) { "-user%!" }
      it "should not be valid" do
        expect(subject).to_not be_valid
      end
    end

    context "when nil" do
      let(:username) { nil }
      it "should be valid" do
        expect(subject).to be_valid
      end
    end

    context "valid" do
      let(:username) { "username_12" }
      it "should be valid" do
        expect(subject).to be_valid
      end
    end
  end

  describe "#invitations_received" do
    subject { user }
    let(:user) { create :user }
    let!(:invitation) { create :invitation, friend: user }
    let(:result) { subject.invitations_received }

    it "should return list of user's invitations received" do
      expect(result).to eq [invitation]
    end
  end

  describe "#full_name" do
    before do
      subject.first_name = "first"
      subject.last_name = "last"
    end

    it "should return full name" do
      expect(subject.full_name).to eq "first last"
    end
  end

  describe ".find_name_by_id(id)" do
    let(:result) { subject.class.find_name_by_id(user.id) }

    context "user found" do
      let(:user) { create :user, first_name: "first", last_name: "last" }

      it "should return the user's full name" do
        expect(result).to eq "first last"
      end
    end

    context "no user found" do
      let(:user) { build_stubbed :user }

      it "should return nil" do
        expect(result).to eq nil
      end
    end
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

    context "no user found" do
      it "should create a new user with auth info" do
        expect { result }.to change(User, :count).by(1)
      end

      it "should create new auth" do
        expect { result }.to change(Authorization, :count).by(1)
      end
    end
  end

  describe ".find_and_update_from_omniauth" do
    let(:result) { subject.class.find_and_update_from_omniauth(auth) }
    let(:auth) { create :omniauth }

    context "matching auth found" do
      let!(:authorization) { create :authorization, uid: auth.uid, provider: auth.provider }

      it "should return the auth's user" do
        expect(result).to eq authorization.user
      end

      it "should update auth data" do
        result
        expect(authorization.reload.data).to eq auth
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

  describe "#find_invitation(friend)" do
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

  describe "#social_profiles" do
    subject { user }
    let(:result) { subject.social_profiles }
    let(:user) { create :user }

    context "with linked social profiles" do
      let(:provider) { "facebook" }
      let!(:authorization) { create :authorization, user: user, provider: provider }

      it "should return the providers" do
        expect(result).to eq [provider]
      end
    end

    context "without linked social profiles" do
      it "should return empty" do
        expect(result).to eq []
      end
    end
  end

  describe "#social_profile_linked?(provider)" do
    subject { user }
    let(:result) { subject.social_profile_linked?(provider) }
    let(:user) { create :user }

    context "social profile is linked" do
      let!(:authorization) { create :authorization, user: user, provider: provider }
      let(:provider) { "facebook" }

      it "should return true" do
        expect(result).to eq true
      end
    end

    context "social profile isnt linked" do
      let!(:authorization) { create :authorization, user: user, provider: "facebook" }
      let(:provider) { "linkedin" }

      it "should return false" do
        expect(result).to eq false
      end
    end
  end

  describe "#social_profile_auth(providers_list)" do
    subject { user }
    let(:result) { subject.social_profile_auths(providers_list) }
    let!(:authorization) { create :authorization, user: user, provider: "facebook" }
    let(:user) { create :user }

    context "no match" do
      let(:providers_list) { ["twitter"] }

      it "should return empty array" do
        expect(result).to eq []
      end
    end

    context "given array of providers" do
      let(:providers_list) { ["facebook", "twitter"] }

      it "should return authorizations that match" do
        expect(result).to eq [authorization]
      end
    end
  end

  describe ".fuzzy_search(query)" do
    let(:result) { subject.class.fuzzy_search(query) }
    before do
      create :user, username: "Jimmy2131"
      create :user, first_name: "Jim2013"
      create :user, last_name: "Yo"
    end

    context "given query" do
      let(:query) { "jim" }
      it "should return users matching any of fields" do
        expect(result.count).to eq 2
      end
    end

    context "empty query" do
      let(:query) { nil }
      it "should return empty" do
        expect(result).to eq []
      end
    end
  end

  describe ".build_query_string" do
    let(:result) { subject.class.build_query_string }

    it "should return query string of autocomplete fields" do
      expect(result).to eq "LOWER(first_name) LIKE :query OR LOWER(last_name) LIKE :query OR LOWER(username) LIKE :query"
    end
  end

  describe ".fully connected?" do
    let(:result) { subject.fully_connected? }
    before { subject.stub(:social_profiles) { social_profiles } }

    context "fully connected" do
      let(:social_profiles) { ["twitter", "linkedin", "gplus", "facebook"] }
      it "should return true" do
        expect(result).to eq true
      end
    end

    context "not fully connected" do
      let(:social_profiles) { ["twitter"] }
      it "should return false" do
        expect(result).to eq false
      end
    end
  end
end
