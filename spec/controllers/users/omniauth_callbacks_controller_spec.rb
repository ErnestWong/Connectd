require 'rails_helper'

describe Users::OmniauthCallbacksController do
  render_views

  context "facebook" do
    subject { post :facebook }
    let(:omniauth) { build :omniauth }

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = omniauth
    end

    context "without existing user" do
      it "should create new user" do
        expect { subject }.to change(User, :count).by(1)
      end

      it "should add to authorizations" do
        expect { subject }.to change(Authorization, :count).by(1)
      end

      it "should redirect to root url" do
        subject
        expect(response).to redirect_to root_url
      end
    end

    context "with existing user with existing omniauth" do
      let!(:user) { create :user }
      let!(:authorization) { create :authorization, uid: omniauth.uid, provider: omniauth.provider }

      it "should not create new user" do
        expect { subject }.to_not change(User, :count)
      end

      it "should not add to authorizations" do
        expect { subject }.to_not change(Authorization, :count)
      end

      it "should redirect to root url" do
        subject
        expect(response).to redirect_to root_url
      end
    end

    context "with logged in user" do
      let!(:user) { create :user }

      before { sign_in user }

      context "without auth" do
        it "should not create new user" do
          expect { subject }.to_not change(User, :count)
        end

        it "should add to authorizations" do
          expect { subject }.to change(Authorization, :count).by(1)
        end

        it "should add to current user's authorizations" do
          subject
          expect(user.authorizations.count).to eq 1
        end

        it "should redirect to users path" do
          subject
          expect(response).to redirect_to user_path(user)
        end
      end

      context "with auth with same provider" do
        let!(:authorization) { create :authorization, user: user, uid: omniauth.uid, provider: omniauth.provider }

        it "should not create new user" do
          expect { subject }.to_not change(User, :count)
        end

        it "should not add to authorizations" do
          expect { subject }.to_not change(Authorization, :count)
        end

        it "should redirect to users path" do
          subject
          expect(response).to redirect_to user_path(user)
        end
      end
    end
  end
end
