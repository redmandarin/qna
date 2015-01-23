class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    end
  end

  def twitter
    if Authorization.where(provider: request.env['omniauth.auth'].provider, uid: request.env['omniauth.auth'].uid).count != 0
      @user = User.find_for_oauth(request.env['omniauth.auth'])
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
    else
      session[:oauth_provider] = request.env['omniauth.auth'].provider
      session[:oauth_uid] = request.env['omniauth.auth'].uid
      redirect_to new_user_registration_path
    end
  end
end
