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

    existingInvitations = Invitation.where(user_id: current_user.id, friend_id: invitation_params[:friend_id])

    twitter_credentials = current_user.authorizations.find_by_provider(:twitter)

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "lGJcPrnQCrMfLvhYlSRQCnEef"
      config.consumer_secret     = "dYKcPlUibwIW2EI0Bn51LotigUKdWpZofbcBIdYWzUshsjHRCg"
      config.access_token        = twitter_credentials.token
      config.access_token_secret = twitter_credentials.token_secret
    end

    if existingInvitations.length >= 1
      flash[:notice] = "invitation already sent"
      @user = User.find_by_id!(invitation_params[:friend_id])
      render "users/show"
    elsif @invitation.save
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

  def social_params
    params.require(:invitation).permit(socials: [])
  end

  def get_socials
    list = social_params[:socials] || []
    list.reject{ |s| s.empty? }
    current_user.social_profile_auths(list)
  end
end
