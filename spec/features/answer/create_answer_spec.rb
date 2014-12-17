require "rails_helper"

feature "Create Answer", %q{
  In order to help people with theirs problems
  As an User
  I want to be able to create answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario "create answer" do
    sign_in(another_user)

    visit question_path(question)
    click_on "Ответить"
    fill_in "Ответ", with: "Some text"
    click_on "Сохранить ответ"

    expect(page).to have_content('Some text')
    expect(page).to have_content("Автор: #{another_user.name}")
  end

  scenario "authenticated user try to create answer without text" do
    sign_in(another_user)
    visit(question_path(question))

    click_on 'Ответить'
    fill_in "Ответ", with: ""
    click_on "Сохранить ответ"

    expect(page).to have_content("Ответ не может быть пустым.")
  end
end