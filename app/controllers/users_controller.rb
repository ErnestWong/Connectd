class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user ||= current_user
  end

  def invite
    @user ||= current_user
    @invitation = Invitation.new
    render 'users/invite'
  end

  def searchIndex
    @user = User.new
    render 'search'
  end

protected

  def search
    searchResults = User.query(profile_params[:search_query])
    # when there is only one search result, show the user's profile directly
    if(searchResults.length == 1)
      @user = searchResults.first
      render 'show'
    else
      @search_query = profile_params[:search_query]
      render 'no_results'
    end
  end

  def profile_params
    params.permit(:search_query)
  end
end
