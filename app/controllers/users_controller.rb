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

  def profile
    @user = User.find_by_username!(params[:username])
  end

protected

  def invitation_params
    params.require(:user).permit(:username)
  end
end
