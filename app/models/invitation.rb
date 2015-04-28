class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  has_many :social_profiles

  validates :user_id, :friend_id, presence: true
  validate :friend_exists?, :invitation_exists?, :invite_self?
  
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
