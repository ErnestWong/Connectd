require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create :user }

  describe "GET show" do
    subject { get :show, id: user.to_param }

    context "user signed in" do
      before { sign_in user }

      it "should render show" do
        subject
        expect(response).to render_template(:show)
      end
      
      it "should assign user to user" do
        subject
        expect(assigns(:user)).to eq user
      end
    end
  end

  describe "POST invite" do
  end

  describe "GET show" do
  end
end
