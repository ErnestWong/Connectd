require 'rails_helper'

RSpec.describe Users::SearchController, type: :controller do
  render_views
  let(:user) { create :user }

  describe "GET autocomplete" do
    subject { get :autocomplete, search: params }
    let(:params) { { query: "user" } }

    context "without logging in" do
      it "should redirect to signin page" do
        subject
        expect(response).to redirect_to new_user_session_path 
      end
    end

    context "user logged in" do
      before { sign_in user }

      it "should render json autocomplete" do
        subject
        expect(response).to render_template "users/search/autocomplete.json"
      end
    end
  end
end
