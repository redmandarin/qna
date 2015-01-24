class RegistrationsController < Devise::RegistrationsController

  def create
    if session['devise.oauth']
      oauth_hash = OmniAuth::AuthHash.new(session['devise.oauth'], info: {})
      oauth_hash.info[:email] = params[:user][:email]
      @user = User.find_for_oauth(oauth_hash)
      sign_in_and_redirect @user, event: :authentication
    else
      super
    end
  end
end