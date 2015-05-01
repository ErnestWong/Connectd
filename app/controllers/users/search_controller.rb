class Users::SearchController < ApplicationController
  before_action :authenticate_user!

  respond_to :json, only: [:autocomplete]

  def autocomplete
    @users_results = User.fuzzy_search(search_params[:query])
    render "users/search/autocomplete.json"
  end

protected
  
  def search_params
    params.require(:search).permit(:query)
  end
end
