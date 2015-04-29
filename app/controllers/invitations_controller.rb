class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new
    @invitation = current_user.invitations.build(invitation_params)

    if @invitation.save
      flash[:notice] = "invitation sent"
      redirect_to user_path(current_user) 
    else
      flash[:notice] = "invitation failed"
      @user = current_user
      render "new"
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
