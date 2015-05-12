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
        if twitter_provider && friend.social_profile_linked?("twitter")
          client = SocialApiClients.getTwitter(twitter_provider);
          client.follow(friend.social_profile_auths([:twitter])[0].data.extra.raw_info.screen_name)
        end
      when "linkedin"
        linkedin_provider = current_user.authorizations.find_by_provider(:linkedin)
        if linkedin_provider && friend.social_profile_linked?("linkedin")
          client = SocialApiClients.getLinkedIn(linkedin_provider)
          email = friend.social_profile_auths([:linkedin])[0].email
          client.send_invitation({:email => email})
        end
      when "facebook"
        facebook_provider = current_user.authorizations.find_by_provider(:facebook)
        if facebook_provider && friend.social_profile_linked?("facebook")
          # TO DO
          client = SocialApiClients.getFacebook(facebook_provider)
          email = friend.social_profile_auths([:facebook])[0].data.info.urls["Facebook"]
        end
      when "gplus"
        # TO DO: investigate why responses are 403
        gplus_provider = current_user.authorizations.find_by_provider(:gplus)
        if gplus_provider && friend.social_profile_linked?("gplus")
          client = SocialApiClients.getGPlus(gplus_provider)
          plus = client.discovered_api('plusDomains')
          userId = @invitation.friend.social_profile_auths([:gplus])[0].data.extra.raw_info.id
          data = client.execute api_method: plus.circles.add_people,
                                parameters: {circleId: "Following", userId: userId}
        end
      end
    end
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

  def social_params
    params.require(:invitation).permit(socials: [])
  end

  def get_socials
    list = social_params[:socials] || []
    list.reject{ |s| s.empty? }
    current_user.social_profile_auths(list)
  end
end
