require_relative "../feature_helper"

feature 'User sign in', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Вход в систему выполнен.'
    expect(current_path).to eq(root_path)
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Эл. почта', with: 'nonuser@email.com'
    fill_in 'Пароль', with: "12345678"
    click_on 'Log in'

    expect(page).to have_content('Неверный email или пароль.')
    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'Non-registered user try to sign_in via twitter' do
    visit new_user_session_path
    click_on 'Sign in with Twitter'
    fill_in 'Эл. почта', with: 'new_twitter_mail@mail.com'
    click_on 'Зарегистрироваться'

    expect(page).to have_content('Вы должны подтвердить Вашу учётную запись.')
  end

  scenario 'registered(have email) user try to sign in via twitter' do
    sign_in(user)
    click_on 'выйти'
    visit new_user_session_path
    click_on 'Sign in with Twitter'
    fill_in 'Эл. почта', with: 'new_twitter_mail@mail.com'
    click_on 'Зарегистрироваться'

    expect(page).to have_content('Вы должны подтвердить Вашу учётную запись.')
  end

  scenario 'send confirmation email if user have account but sign in via twitter'
end