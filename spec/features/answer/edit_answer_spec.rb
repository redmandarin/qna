require_relative '../feature_helper.rb'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of the Answer
  I want to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Unauthenticated user try to edit the answer' do
    visit question_path(question)

    expect(page).to_not have_link('редактировать ответ')
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      within('.answers') do
        expect(page).to have_link('редактировать ответ')
      end
    end

    scenario 'try to edit his answer', js: true do
      within '.answers' do
        click_on('редактировать ответ')
        fill_in 'Ответ', with: "edited answer"
        click_on 'Сохранить ответ'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector('textarea')
      end
    end

    scenario 'try to edit not his answer', js: true do
      click_on 'выйти'
      sign_in(another_user)
      visit question_path(question)
      
      within '.answers' do
        expect(page).not_to have_link('редактировать ответ')
      end
    end
  end
end