require_relative "../feature_helper"

feature "User answer", %q{
  In order to commenting questions and answers
  As User
  I want to be able to create comments
} do

  given(:question) { create(:question_with_answer) }
  given(:user) { create(:user) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit(question_path(question))
    end
    
    scenario "create comment for question with valid attributes", js: true do
      within ".question" do
        click_on 'Добавить комментарий'
        fill_in 'Комментарий', with: "Some words"
        click_on('Сохранить комментарий')
      end

      expect(page).to have_content("Some words")
      expect(page).to have_content(user.name)
    end

    scenario "create comment for question with invalid attributes", js: true do
      within ".question" do
        click_on 'Добавить комментарий'
        fill_in 'Комментарий', with: ""
        click_on('Сохранить комментарий')
      end

      expect(page).to have_content("Комментарий не может быть пустым.")
    end

  end

  scenario "not signed_in user try to create comment" do
    visit(question_path(question))

    expect(page).not_to have_content("Добавить комментарий")
  end
end