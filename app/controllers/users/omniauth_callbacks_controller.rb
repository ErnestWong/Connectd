class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  User.omniauth_providers.each do |provider|
    define_method(provider) { handle_user(provider.to_s) }
  end

  def login_or_signup_user(provider)
    @user = User.find_or_create_from_omniauth(auth)

    if @user && @user.persisted?
      sign_in_and_redirect @user
    else
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to new_user_registration_url, alert: 'Authentication failed, please try again.'
  end

  def handle_user(provider)
    if current_user
      add_oauth_to_user(provider)
    else
      login_or_signup_user(provider)
    end
  end

  def add_oauth_to_user(provider)
    unless current_user.social_profile_linked?(provider)
      binding.pry
      current_user.authorizations << Authorization.build_from_omniauth(auth)
      redirect_to user_path(current_user), alert: "Added #{provider} to account"
    else
      redirect_to user_path(current_user), alert: "Already added #{provider} to account"
    end
  end

private

  def auth
    @auth ||= request.env["omniauth.auth"]
  end
end
