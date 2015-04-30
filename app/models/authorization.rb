class Authorization < ActiveRecord::Base
  belongs_to :user

  serialize :data

  def self.build_from_omniauth(auth)
    new(uid: auth.uid, provider: auth.provider, data: auth)
  end

  def self.auth_exists?(auth)
    Authorization.find_by_uid(auth.uid)
  end

  def is_twitter?
    provider.downcase == "twitter"
  end
end
