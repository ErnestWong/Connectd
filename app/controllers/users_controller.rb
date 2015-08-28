class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update, :invite, :searchIndex, :username_check]
  before_action :load_user, only: [:show, :update, :invite, :username_check]

  respond_to :json, only: [:username_check, :update, :search, :invite, :update_attributes]

  def update
    @user.update_attributes(user_params)
    if @user.save
      flash[:notice] = "successfully updated username"
      respond_to do |format|
          format.html { redirect_to user_path(@user) }
          format.json { render json: @user }
      end
    else
      respond_to do |format|
          format.html { render "show" }
          format.json { render json: @user }
      end
    end
  end

  def invite
    @invitation = Invitation.new
    respond_to do |format|
        format.html { render 'users/invite' }
        format.json { render json: @invitation }
    end
  end

  def searchIndex
    @user = User.new
    render 'search'
  end

  def username_check
    @user.update_attributes(user_params) 
    @user.valid?
    @errors = @user.errors.messages[:username]
    render "users/username_check.json"
  end

  def search
    searchResults = User.query(profile_params[:search_query])
    if(searchResults.length > 1)
      # render template with list of results
      @search_query = profile_params[:search_query]
      @results = searchResults
      respond_to do |format|
          format.html { render 'show_search_results' }
          format.json { render json: @results }
      end
    elsif(searchResults.length == 1)
      # when there is only one search result, show the user's profile directly
      @user = searchResults.first
      respond_to do |format|
          format.html { render 'show' }
          format.json { render json: @user }
      end
    else
        @search_query = profile_params[:search_query]
        # display no_results page on no results
        respond_to do |format|
            format.html { render 'no_results' }
            format.json { render json: @search_query }
        end
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
