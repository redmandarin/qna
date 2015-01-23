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

# ты делаешь редирект на какой-то другой контроллер (registrations, например), там вводим email и отправляем форму на экшена тоже в контроллер регистрации, где создаем юзера с введенными данными, а также создаем для него связку для соц. сети (authorization) данные для которой берем из сессии

# Нормально ли решение для твиттер аутентификации? При коллбеке сохраняем в сессию request.env['omniauth.auth'] и callback url по которому пришел запрос, далее редиректим на страницу с имейл формой, добавляем имейл в info.email и делаем опять запрос на коллбек юрл уже с имейлом.