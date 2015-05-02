require 'rails_helper'

RSpec.describe Authorization, type: :model do
  subject { build_stubbed :authorization }

  describe ".build_from_omniauth" do
    let(:result) { subject.class.build_from_omniauth(auth) }
    let(:auth) { build :omniauth }

    it "should return new authorization" do
      expect(result).to be_a Authorization
    end

    it "should have uid of auth" do
      expect(result.uid).to eq auth.uid
    end

    it "should have provider of auth" do
      expect(result.provider).to eq auth.provider
    end
  end

  describe ".auth_exists?(auth)" do
    subject { build_stubbed :authorization, uid: omniauth }
    let(:omniauth) { create :omniauth }
    let(:result) { subject.class.auth_exists?(subject) }

    context "uid already exists" do
      let!(:auth) { create :authorization, uid: omniauth }

      it "should return the authorization" do
        expect(result).to eq auth
      end
    end

    context "uid doesnt exist" do
      it "should return nil" do
        expect(result).to eq nil
      end
    end
  end

  describe ".email" do
    subject { build_stubbed :authorization, data: omniauth }
    let(:omniauth) { create :omniauth, info: info }
    let(:info) {
      {
        email: "email@email.com"
      }
    }
    let(:result){ subject.email }

    it "should return email" do
      expect(result).to eq info[:email]
    end
  end
end
