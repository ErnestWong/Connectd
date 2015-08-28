class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @invitations = current_user.invitations
    @received_invitations = current_user.invitations_received
  end

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = current_user.invitations.build(invitation_params)
    @invitation.authorizations = get_socials
    friend = @invitation.friend
    if @invitation.save
      @invitation.authorizations.each do |authorization|
        Invitation.request(authorization.provider, current_user, friend);
      end
      flash[:notice] = "invitation sent"
      respond_to do |format|
          format.html { redirect_to user_path(current_user) }
          format.json { render json: @invitation }
      end
    else
      flash[:notice] = "invitation failed"
      @user = current_user
      respond_to do |format|
          format.html { render "new" }
          format.json { render json: @user }
      end
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

  def social_params
    params.require(:invitation).permit(socials: [])
  end

  def get_socials
    list = social_params[:socials] || []
    list.reject{ |s| s.empty? }
    current_user.social_profile_auths(list)
  end
end
