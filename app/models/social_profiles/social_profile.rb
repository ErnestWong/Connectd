class SocialProfile < ActiveRecord::Base
  belongs_to :user
  belongs_to :invitation, through: :user
end
