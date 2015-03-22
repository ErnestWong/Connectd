class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @invitation = current_user.invitations.build(invitation_params)
    if @invitation.save
      flash[:notice] = "invitation sent"
      @user = User.find_by_username!('peterchu')
      render 'users/show'
    else
      flash[:notice] = "invitation failed"
      @user = current_user
      render "users/show"
    end
  end

  def destroy
    @invitation = current_user.invitations.find(params[:friend_id])
    @invitation.destroy
    flash[:notice] = "Cancelled invitation"
    redirect_to current_user
  end

protected
  def invitation_params
    params.require(:invitation).permit(:friend_id)
  end
end
