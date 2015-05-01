require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:user) { create :user }

  describe "POST create" do
    subject { post :create, invitation: params }
    let(:params) { { friend_id: friend_id, socials: ["facebook"] } }
    before { sign_in user }

    context "valid invitation" do
      let!(:friend_user) { create :user }
      let(:friend_id) { friend_user.id }
      let!(:authorization) { create :authorization, user: user, provider: "facebook" }

      it "should send invitation to user" do
        subject
        expect(user.invitations.count).to eq 1
      end

      it "should create new invitation" do
        expect { subject }.to change(Invitation, :count).by(1)
      end

      it "should assign the authorization to invitation" do
        subject
        expect(assigns(:invitation).authorizations).to eq [authorization]
      end

      it "should redirect to user path" do
        subject
        expect(response).to redirect_to user_path(user)
      end
    end

    context "invalid invitation" do
      let(:friend_id) { "" }

      it "should not send invitation to user" do
        subject
        expect(user.invitations.count).to eq 0
      end

      it "should not create new invitation" do
        expect { subject }.to_not change(Invitation, :count)
      end

      it "should render invitations new page" do
        subject
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET index" do
  end

  describe "destroy" do
  end
end
