require 'rails_helper'

feature "Edit Question", %{
  In order to correct errors
  As User
  I want to be able to edit the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: user) }

  scenario "auhtor of the question edit question" do
    sign_in(user)

    visit question_path(question)
    title = question.title
    body = question.body
    click_on 'редактировать'
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
    sign_in(user)
    visit question_path(question)

    expect(page).not_to have_link(edit_question_path(question))
  end
end