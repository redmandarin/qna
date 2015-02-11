require_relative '../feature_helper'

feature 'Add subscription', %q{
  In order to receive update
  As an User
  I want to be able to get update for the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  
  scenario 'create', js: true do
    sign_in(user)
    visit question_path(question)
    # click_on 'подписaться на обновления'
    click_on 'подписаться на обновления'
    expect(page).to have_content('вы подписаны на обновления')
  end
end
