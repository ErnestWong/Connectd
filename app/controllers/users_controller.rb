class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user ||= current_user
    render 'show'
  end

  def invite
    @user ||= current_user
    @invitation = Invitation.new
    render 'users/invite'
  end

end
