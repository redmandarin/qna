class RegistrationsController < Devise::RegistrationsController

  def create
    if session[:oauth_provider] && session[:oauth_uid]
      oauth_hash = OmniAuth::AuthHash.new(provider: session[:oauth_provider], uid: session[:oauth_uid], info: { email: params[:user][:email] })
      @user = User.find_for_oauth(oauth_hash)
      sign_in_and_redirect @user, event: :authentication
      # resource.authorizations.create(provider: session[:oauth_provider], uid: session[:oauth_uid])
    else
      super
    end
  end

end