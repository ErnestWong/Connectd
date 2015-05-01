class Authorization < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :invitations

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
