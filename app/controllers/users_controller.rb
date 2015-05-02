class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:show, :update, :invite]

  respond_to :json, only: [:username_valid]

  def update
    @user.update_attributes(user_params)
    if @user.save
      flash[:notice] = "successfully updated username"
      redirect_to user_path(@user)
    else
      render "show"
    end
  end

  def invite
    @invitation = Invitation.new
    render 'users/invite'
  end

  def searchIndex
    @user = User.new
    render 'search'
  end

  def username_valid
  end

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

protected

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username)
  end
  def profile_params
    params.permit(:search_query)
  end
end
