require_relative "../feature_helper"

feature 'Add vote to answer', %q{
  It order make dicision
  As an User
  I want to be able to make vote
} do

  # given(:user) { create(:user) }
  given!(:a_user) { create(:user) }
  given!(:question) { create(:question, user: create(:user)) }
  given!(:answer) { create(:answer, user: create(:user), question: question) }

  background do
    sign_in(a_user)
    visit question_path(question)
  end

  scenario 'not authenticated user does not see vote link', js: true do
    click_on 'выйти'
    visit question_path(question)

    within '.answer-votes' do
      expect(page).not_to have_content("голосовать за ответ")
      expect(page).not_to have_content("голосовать против")
    end
  end

  scenario 'Add -1 vote to answer', js: true do
    within '.answer-votes' do
      click_on 'голосовать против'
      sleep(1)
      expect(page).to have_content('-1')
    end
  end

  scenario 'Add +1 vote to answer', js: true do
    within '.answer-votes' do
      click_on 'голосовать за'
      expect(page).to have_content('1')
    end
  end

  scenario 'update +1 vote to answer', js: true do
    visit question_path(question)
    within '.answer-votes' do
      click_on 'голосовать против'
      click_on 'голосовать за'
      expect(page).to have_content('1')
    end
  end

end
