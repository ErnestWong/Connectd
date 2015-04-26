class Authorization < ActiveRecord::Base
  belongs_to :user

  serialize :data

  def self.build_from_omniauth(auth)
    new(uid: auth.uid, provider: auth.provider)
  end
end
