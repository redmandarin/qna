require_relative "../feature_helper"

feature "Create Answer", %q{
  In order to help people with theirs problems
  As an User
  I want to be able to create answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario "Authenticated user create answer", js: true do
    sign_in(user)
    visit question_path(question)

    within '.new_answer_form' do
      fill_in "Ответ", with: "Some text"
      click_on "Сохранить ответ"
    end

    expect(current_path).to eq(question_path(question))
    within '.answers' do
      expect(page).to have_content('Some text')
      # expect(page).to have_content("Автор: #{another_user.name}")
    end
  end

  scenario 'User try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new_answer_form' do
      click_on 'Сохранить ответ'
    end
    
    expect(page).to have_content('Ответ не может быть пустым')
  end
end