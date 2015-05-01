class Users::SearchController < ApplicationController
  def autocomplete
    @users_results = User.fuzzy_search
  end
end
