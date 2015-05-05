class SocialApiClients
  def self.getTwitter(twitter_provider)
    client = Twitter::REST::Client.new do |config|
            config.consumer_key        = ENV['TWITTER_APP_ID']
            config.consumer_secret     = ENV['TWITTER_APP_SECRET']
            config.access_token        = twitter_provider.data.credentials.token
            config.access_token_secret = twitter_provider.data.credentials.secret
          end
    client
  end

  def self.getLinkedIn(linkedin_provider)
    client = LinkedIn::Client.new(ENV['LINKEDIN_APP_ID'], ENV['LINKEDIN_APP_SECRET'])
          client.authorize_from_access(linkedin_provider.data.credentials.token, linkedin_provider.data.credentials.secret)
    client
  end

  def self.getFacebook(facebook_provider)
    # TO DO
  end

  def self.getGPlus(gplus_provider)
    client = Google::APIClient.new
          client.authorization.client_id = ENV['GPLUS_APP_ID']
          client.authorization.client_secret = ENV['GPLUS_APP_SECRET']
          client.authorization.access_token = gplus_provider.data.credentials.token
          # client.authorization.scope = %w^openid
          #                           https://www.googleapis.com/auth/plus.circles.write
          #                           https://www.googleapis.com/auth/plus.circles.read
          #                           https://www.googleapis.com/auth/plus.me
          #                           https://www.googleapis.com/auth/plus.login^
    client
  end
