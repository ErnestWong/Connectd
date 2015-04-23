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
end
