module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Эл. почта', with: user.email
    fill_in 'Пароль', with: user.password
    click_on 'Log in'
  end
end