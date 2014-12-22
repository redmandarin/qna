require_relative "../feature_helper"

feature 'Destroy question', %q{
  In order to be able to destroy question
  As an User
  I want to be able to destroy question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  scenario 'Signed in user(author) try to destroy question' do
    sign_in user

    visit question_path(question)
    click_on 'удалить вопрос'
    expect(page).to have_content('Вопрос успешно удален.')
    expect(current_path).to eq(questions_path)
  end

  scenario 'Signed in user(non-author) try to destroy' do
    sign_in another_user

    visit question_path(question)
    expect(page).not_to have_link('удалить вопрос')
  end
  
end