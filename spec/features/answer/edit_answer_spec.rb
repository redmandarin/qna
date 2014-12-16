require "rails_helper"

feature "edit Answer", %q{
  In order to correct errors
  As an User
  I want to be able to edit an answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

  scenario "edit answer as author" do
    sign_in(user)
    answer
    visit question_path(question)

    click_on 'редактировать ответ'
    fill_in 'Ответ', with: "New text"
    click_on 'Сохранить ответ'

    expect(page).to have_content('New text')
  end

  scenario "edit as non author" do
    sign_in(another_user)
    answer
    visit question_path(question)

    expect(page).not_to have_content("редактировать ответ")
  end
end