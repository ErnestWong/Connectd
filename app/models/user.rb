class User < ActiveRecord::Base
  has_many :invitations
  has_many :friends, through: :invitations
  has_many :social_profiles
  has_many :authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable,
    :validatable, :authentication_keys => [:login]

  devise :omniauthable, :omniauth_providers => [:facebook, :twitter, :gplus, :linkedin]

  attr_accessor :login

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def self.find_or_create_from_omniauth(auth)
    find_from_omniauth(auth) || create_from_omniauth(auth)
  end

  def self.find_from_omniauth(auth)
    Authorization.where(uid: auth.uid).first.try(:user) || User.where(email: auth.info.email).first
  end

  def self.create_from_omniauth(auth)
    authorization = Authorization.build_from_omniauth(auth)

    User.create do |user|
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.authorizations = [authorization]
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.search_username(user_name)
    if user_name
      user_name.downcase!
      where('LOWER(username) LIKE ?', "%#{user_name}%")
    end
  end

  def self.query(query)
    if query
      query.downcase!
      where('LOWER(username)=? OR LOWER(email)=?
        OR LOWER(first_name)=? OR LOWER(last_name)=?',
        query, query, query, query)
    end
  end

  def find_invitation(friend)
    self.invitations.find_by_friend_id(friend.id) unless friend.nil?
  end

  def social_profiles
    self.authorizations.pluck(:provider)
  end

private

  def self.search_username(user_name)
    if user_name
      user_name.downcase!
      where('LOWER(username) LIKE ?', "%#{user_name}%")
    end
  end

  def self.query(query)
    if query
      query.downcase!
      where('LOWER(username)=? OR LOWER(email)=?
        OR LOWER(first_name)=? OR LOWER(last_name)=?',
        query, query, query, query)
    end
  end
end
