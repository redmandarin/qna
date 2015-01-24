class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    sign_in_via('facebook')
  end

  def twitter
    sign_in_via('twitter')
  end

  private

  def sign_in_via(provider_name)
    session['devise.oauth'] = request.env['omniauth.auth']
    @user = User.find_for_oauth(session['devise.oauth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name.capitalize) if is_navigational_format?
    else
      redirect_to new_user_registration_path
    end
  end
end
