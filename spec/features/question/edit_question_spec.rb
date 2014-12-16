require 'rails_helper'

feature "Edit Question", %{
  In order to correct errors
  As User
  I want to be able to edit the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario "auhtor of the question edit question" do
    sign_in(user)

    visit question_path(question)
    click_on 'редактировать'
    fill_in 'Заголовок', with: "New"
    fill_in 'Вопрос', with: "Brand New"
    click_on 'Сохранить вопрос'

    expect(page).to have_content('New')
    expect(page).to have_content('Brand New')
    expect(current_path).to eq(question_path(question))
  end
end