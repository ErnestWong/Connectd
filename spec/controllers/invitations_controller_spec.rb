require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:user) { create :user }

  describe "POST create" do
    subject { post :create, invitation: params }
    let(:params) { { friend_id: friend_id } }
    before { sign_in user }

    context "valid invitation" do
      let!(:friend_user) { create :user }
      let(:friend_id) { friend_user.to_param }


      it "should send invitation to user" do
        subject
        expect(user.invitations.count).to eq 1
      end

      it "should create new invitation" do
        expect { subject }.to change(Invitation, :count).by(1)
      end

      it "should return 200 on valid invitation request" do
        subject
        expect(response.status).to eq(200)
      end
    end

    context "invalid invitation" do
      let(:friend_id) { nil }

      it "should not send invitation to user" do
        subject
        expect(user.invitations.count).to eq 0
      end

      it "should not create new invitation" do
        expect { subject }.to_not change(Invitation, :count)
      end

      it "should render users show page" do
        subject
        expect(response).to render_template(:show)
      end
    end
  end

  describe "GET index" do
  end

  describe "destroy" do
  end
end
