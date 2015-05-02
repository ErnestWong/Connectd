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
    @invitation.authorizations.each do |authorization|
      case authorization.provider
      when "twitter"
        twitter_provider = current_user.authorizations.find_by_provider(:twitter)
        if twitter_provider && friend.social_profile_linked?(:twitter)
          client = Twitter::REST::Client.new do |config|
            config.consumer_key        = ENV['TWITTER_APP_ID']
            config.consumer_secret     = ENV['TWITTER_APP_SECRET']
            config.access_token        = twitter_provider.data.credentials.token
            config.access_token_secret = twitter_provider.data.credentials.secret
          end
          client.follow(friend.social_profile_auths([:twitter])[0].data.extra.raw_info.screen_name)
        end
      when "linkedin"
        linkedin_provider = current_user.authorizations.find_by_provider(:linkedin)
        if linkedin_provider && friend.social_profile_linked?(:linkedin)
          consumer_options = {
            :request_token_path => "/uas/oauth/requestToken?scope=r_fullprofile+rw_network+rw_nus+rw_emailaddress+rw_groups",
            :access_token_path  => "/uas/oauth/accessToken",
            :authorize_path     => "/uas/oauth/authorize",
            :api_host           => "https://api.linkedin.com",
            :auth_host          => "https://www.linkedin.com"
          }
          client = LinkedIn::Client.new(ENV['LINKEDIN_APP_ID'], ENV['LINKEDIN_APP_SECRET'], consumer_options)
          client.authorize_from_access(linkedin_provider.data.credentials.token, linkedin_provider.data.credentials.secret)
          email = friend.social_profile_auths([:linkedin])[0].email
          client.send_invitation({:email => email, :first_name => @invitation.friend.first_name, :last_name => @invitation.friend.last_name})
        end
      when "facebook"
        facebook_provider = current_user.authorizations.find_by_provider(:facebook)
        if facebook_provider && friend.social_profile_linked?(:facebook)
          # TO DO
        end
      when "gplus"
        gplus_provider = current_user.authorizations.find_by_provider(:gplus)
        if gplus_provider && friend.social_profile_linked?(:gplus)
          client = Google::APIClient.new
          client.authorization.client_id = ENV['GPLUS_APP_ID']
          client.authorization.client_secret = ENV['GPLUS_APP_SECRET']
          client.authorization.access_token = gplus_provider.data.credentials.token
          # plus = client.discovered_api('plus')
          plus = client.discovered_api('plusDomains')
          userId = @invitation.friend.social_profile_auths([:gplus])[0].data.extra.raw_info.id
          data = client.execute api_method: plus.circles.add_people,
                                parameters: {circleId: "Following", userId: userId}
        end
      end
    end

    existingInvitations = Invitation.where(user_id: current_user.id, friend_id: invitation_params[:friend_id])

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
