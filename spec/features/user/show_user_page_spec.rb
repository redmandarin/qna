require_relative '../feature_helper'

feature 'show User page', %q{
  In order to be able watch user profile
  As an User
  I want to be able to see User page
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user see page' do
    visit user_path(user)
    user.reload

    expect(page).to have_content(user.email)
    expect(page).to have_content(user.questions.first.title)
  end
end