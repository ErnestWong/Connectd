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
end
