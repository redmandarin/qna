require_relative '../feature_helper'

feature 'Edit comment', %q{
  In order to be able fix errors
  As User
  I want to be able to edit comment
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:comment) { create(:comment, user_id: user.id, commentable: question) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "author try to edit comment with valid attributes", js: true do
      within '.comment' do
        click_on 'редактировать'
        fill_in 'Комментарий', with: "New comment text"
        click_on 'Сохранить комментарий'
        expect(page).to have_content("New comment text")
      end

    end

    scenario "edit comment with invalid attributes", js: true do 
      within '.comment' do
        click_on 'редактировать'
        fill_in 'Комментарий', with: ""
        click_on 'Сохранить комментарий'
      end

      expect(page).to have_content("Комментарий не может быть пустым.")
    end

    scenario "not author try to edit comment" do
      click_on 'выйти'
      sign_in(another_user)
      visit question_path(question)

      within ".comment" do
        expect(page).not_to have_content("редактировать")
      end
    end
  end

  scenario "Unauthenticated user" do
    visit question_path(question)
    expect(page).not_to have_content("редактировать")
  end
end