class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  has_and_belongs_to_many :authorizations

  validates :user_id, :friend_id, presence: true
  validate :friend_exists?, :invitation_exists?, :invite_self?

  def social_profiles
    authorizations.pluck(:provider).map(&:downcase)
  end

  def request(provider, current_user, friend)
    case provider
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
        userId = friend.social_profile_auths([:gplus])[0].data.extra.raw_info.id
        data = client.execute api_method: plus.circles.add_people,
                              parameters: {circleId: "Following", userId: userId}
      end
    end

  end
protected

  def friend_exists?
    if User.where(id: friend_id).blank?
      errors.add(:friend_id, "invalid id")
    end
  end

  def invitation_exists?
    errors.add(:friend_id, "already invited user") if user.find_invitation(self.friend)
  end

  def invite_self?
    errors.add(:friend_id, "cant invite yourself") if self.user.id == friend_id
  end
end
