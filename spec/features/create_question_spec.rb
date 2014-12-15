require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates questions' do

sign_in(user)

    visit questions_path
    click_on 'Задать вопрос'
    fill_in 'Заголовок', with: 'Test question'
    fill_in 'Вопрос', with: 'Тело вопроса'
    click_on 'Создать вопрос'

    expect(page).to have_content("Ваш вопрос успешно создан.")
  end

  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'Сначала вам нужно войти или зарегестрироваться.'
  end
  
end

