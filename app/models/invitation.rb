class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  has_many :social_profiles

  validates :user_id, :friend_id, presence: true
  validate :friend_exists?, :invitation_exists?
  
  def friend_exists? 
    if User.where(id: friend_id).blank?
      errors.add(:friend_id, "invalid id")
    end
  end

  def invitation_exists?
    if self.user.invitation(self.friend_id)
  end
end
