require_relative '../feature_helper'

feature 'Add vote to question', %q{
  It order make dicision
  As an User
  I want to be able to make vote
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'not authenticated user does not see vote link', js: true do
    click_on 'выйти'
    visit question_path(question)
    within '.question-votes' do
      expect(page).not_to have_content("голосовать за вопрос")
      expect(page).not_to have_content("голосовать против")
    end

    within '.answer-votes' do
      expect(page).not_to have_content("голосовать за ответ")
      expect(page).not_to have_content("голосовать против")
    end
  end

  scenario 'Add +1 vote to question', js: true do
    within '.question-votes' do
      choose 'vote_value_1'
      expect(page).to have_content('1')
    end
  end

  scenario 'update +1 vote to question', js: true do
    within '.question-votes' do
      choose 'vote_value_-1'
      choose 'vote_value_1'
      expect(page).to have_content('1')
    end
  end

  scenario 'update +1 vote to answer', js: true do
    within '.answer-votes' do
      choose 'vote_value_-1'
      choose 'vote_value_1'
      expect(page).to have_content('1')
    end
  end

  scenario 'Add -1 vote to question', js: true do
    within '.question-votes' do
      choose 'vote_value_-1'
      expect(page).to have_content('-1')
    end
  end

  scenario 'Add +1 vote to answer', js: true do
    within ".answer-votes" do
      choose 'vote_value_1'
      save_and_open_page
      expect(page).to have_content('1')
    end
  end

  # scenario 'Add -1 vote to answer', js: true do
  #   within '.answer-votes' do
  #     choose 'vote_value_-1'
  #     expect(page).to have_content('-1')
  #   end
  # end
end