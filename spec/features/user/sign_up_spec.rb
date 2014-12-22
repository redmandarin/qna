require_relative "../feature_helper"

feature 'User sign up', %q{
  In order to give and recieve help 
  As an non User
  I want to be able to sign up
} do

  scenario 'non User try to sign up' do
    visit new_user_registration_path
    fill_in 'Имя', with: 'My Name'
    fill_in 'Эл. почта', with: 'email@mail.com'
    fill_in 'Пароль', with: '12345678'
    fill_in 'Подтверждение', with: '12345678'
    click_on 'Зарегистрироваться'

    expect(page).to have_content('Вы успешно зарегистрировались.')
    expect(page).to have_content('вы вошли как My Name')
    expect(current_path).to eq(root_path)
  end
  
end