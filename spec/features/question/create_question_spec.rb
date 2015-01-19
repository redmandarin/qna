require_relative "../feature_helper"

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'creates questions' do
      click_on 'Задать вопрос'
      fill_in 'Заголовок', with: 'Test question'
      fill_in 'Вопрос', with: 'Тело вопроса'
      fill_in 'Список тегов', with: 'tag1, tag2'
      click_on 'Сохранить вопрос'

      expect(page).to have_content("Вопрос успешно создан.")
      expect(page).to have_content("tag1")
      expect(page).to have_content("tag2")
      expect(page).to have_content("Автор: #{user.name}")
    end

    scenario 'Authenticated user try to create invalid quesiton' do
      click_on 'Задать вопрос'
      click_on 'Сохранить вопрос'

      expect(page).to have_content('Вопрос не может быть пустым')
    end
  end

  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
    expect(current_path).to eq(new_user_session_path)
  end


end

