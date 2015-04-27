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

  describe "GET searchIndex" do
    subject { get :searchIndex }
    context "user signed in" do
      before { sign_in user }

      it "should render search" do
        subject
        expect(response).to render_template(:search)
      end
    end
  end

  describe "POST search" do
    before { sign_in user }

    context "query with multiple results" do
      it "should search by first name successfully" do
        # create second user with same first name
        user2 = create :user
        params = { search_query: user.first_name }
        post :search, params
        expect(response).to render_template(:show_search_results)
      end
      it "should search by last name successfully" do
        # create second user with same last name
        user2 = create :user
        params = { search_query: user.last_name }
        post :search, params
        expect(response).to render_template(:show_search_results)
      end
    end

    context "query with one result" do
      it "should search by username successfully" do
        params = { search_query: user.username }
        post :search, params
        expect(response).to render_template(:show)
      end
      it "should search by first name successfully" do
        params = { search_query: user.first_name }
        post :search, params
        expect(response).to render_template(:show)
      end
      it "should search by last name successfully" do
        params = { search_query: user.last_name }
        post :search, params
        expect(response).to render_template(:show)
      end
      it "should search by email successfully" do
        params = { search_query: user.email }
        post :search, params
        expect(response).to render_template(:show)
      end
    end

    context "query with no results" do
      it "should render no results page" do
        params = { search_query: "not existent" }
        post :search, params
        expect(response).to render_template(:no_results)
      end
    end
  end
end
