require_relative "../feature_helper"

feature "Edit Question", %{
  In order to correct errors
  As User
  I want to be able to edit the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: user) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
      title = question.title
      body = question.body
      tags = question.tags
    end

    scenario "auhtor of the question edit question", js: true do
      click_on 'редактировать'

      expect(current_path).not_to eq(edit_question_path(question))

      fill_in 'Заголовок', with: "New"
      fill_in 'Вопрос', with: "Brand New"
      fill_in 'Список тегов', with: "another1, another2"
      click_on 'Сохранить вопрос'

      expect(page).to have_content('New')
      expect(page).to have_content('Brand New')
      expect(page).to have_content('another1')
      expect(page).to have_content('another2')
      expect(page).not_to have_content(title)
      expect(page).not_to have_content(body)
      expect(current_path).to eq(question_path(question))
    end

    scenario "not author try to edit question" do
      visit question_path(question)

      expect(page).not_to have_link(edit_question_path(question))
    end

    scenario 'try to edit question with valid attr.', js: true do
      within '.question' do
        click_on 'редактировать'
        fill_in 'Вопрос', with: "New value"
        fill_in 'Заголовок', with: "New title"
        fill_in 'Список тегов', with: "one, two"
        click_on 'Сохранить вопрос'

        expect(page).not_to have_content(title)
        expect(page).not_to have_content(body)
        expect(page).to have_content('New value')
        expect(page).to have_content('New title')
        expect(page).to have_content('one')
        expect(page).to have_content('two')
      end
    end

    scenario 'try to edit question with invalid attr.', js: true do
      within '.question' do
        click_on 'редактировать'
        fill_in 'Вопрос', with: ""
        fill_in 'Заголовок', with: ""
        click_on 'Сохранить вопрос'

        expect(page).to have_content('Вопрос не может быть пустым.')
        expect(page).to have_content('Заголовок не может быть пустым.')
      end
    end
  end


end