class User < ActiveRecord::Base
  has_many :invitations
  has_many :friends, through: :invitations
  has_many :social_profiles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
