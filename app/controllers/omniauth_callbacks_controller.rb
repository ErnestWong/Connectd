class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def login_or_signup_user
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

  def handle_user
    if current_user
      add_oauth_to_user
    else
      login_or_signup_user
    end
  end

  def add_oauth_to_user
    current_user.authorizations << Authorization.build_from_omniauth(auth) unless current_user.authorizations.present?
    redirect_to root_url, alert: 'Added facebook to account'
  end

  def facebook
    handle_user
  end

private

  def auth
    @auth ||= request.env["omniauth.auth"]
  end
end
