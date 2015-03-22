class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user ||= current_user
    @user = User.find_by_permalink(params[:id]) if @user.nil?
    render 'show'
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
    if(searchResults.length > 1)
      # render template with list of results
      @search_query = profile_params[:search_query]
      @results = searchResults
      render 'show_search_results'
    elsif(searchResults.length == 1)
      # when there is only one search result, show the user's profile directly
      @user = searchResults.first
      render 'show'
    else
      # display no_results page on no results
      @search_query = profile_params[:search_query]
      render 'no_results'
    end
  end

  def profile_params
    params.permit(:search_query)
  end
end
