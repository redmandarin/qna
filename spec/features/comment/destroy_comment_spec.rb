require_relative '../feature_helper'

feature 'Destroy comment', %q{
  In order to be able to destroy comment
  As User
  I want to be able destroy comment
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:comment) { create(:comment, user_id: user.id, commentable_id: question.id, commentable_type: "Question") }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'author try to destroy comment', js: true do
      body = comment.body
      click_on('удалить комментарий')
      expect(page).not_to have_content(body)
    end

    scenario 'not author try to destroy comment', js: true do
      click_on 'выйти'
      sign_in(another_user)
      expect(page).not_to have_content('удалить комментарий')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'try to destroy comment' do
      visit question_path(question)
      expect(page).not_to have_content('удалить комментарий')
    end
  end

end