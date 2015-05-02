class User < ActiveRecord::Base
  has_many :invitations
  has_many :friends, through: :invitations
  has_many :authorizations

  validates :username, length: { minimum: 5, maximum: 100 }, allow_nil: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]+\Z/ }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable,
    :validatable, :authentication_keys => [:login]

  devise :omniauthable, :omniauth_providers => [:facebook, :twitter, :gplus, :linkedin]
  AUTOCOMPLETE_FIELDS = ["first_name", "last_name", "username"].freeze

  attr_accessor :login

  def login=(login)
    @login = login
  end

  def login
    @login || username || email
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def social_profiles
    authorizations.pluck(:provider).map(&:downcase)
  end

  def social_profile_auths(providers_list=[])
    authorizations.where("PROVIDER IN (?) ", providers_list)
  end

  def social_profile_linked?(provider=nil)
    social_profiles.include? provider.downcase
  end

  def fully_connected?
    social_medias = User.omniauth_providers.map(&:to_s)
    social_medias.sort == social_profiles.sort
  end

  def invitations_received
    Invitation.where(friend_id: id)
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
    info = auth.info

    User.create do |user|
      if authorization.is_twitter?
        user.first_name, user.last_name = info.name.split(" ")
        user.email = "#{info.name}_#{auth.uid}@dummytwitter.com".gsub(/\s+/, "")
      else
        user.first_name = info.first_name
        user.last_name = info.last_name
        user.email = info.email
      end
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

  def self.fuzzy_search(query)
    query = query.downcase unless query.nil?
    return [] if query.blank?
    where(build_query_string, query: "%#{query}%")
  end

  def find_invitation(friend)
    invitations.find_by_friend_id(friend.id) unless friend.nil?
  end

  def self.find_name_by_id(id)
    user = User.find_by_id(id)
    user.full_name unless user.nil?
  end

private

  def self.build_query_string
    array_query = []
    AUTOCOMPLETE_FIELDS.each do |field|
      array_query << "LOWER(#{field}) LIKE :query"
    end
    array_query.join(" OR ")
  end
end
