require_relative '../feature_helper'

feature 'Mark as best answer', %q{
  In order to help other people
  As an User
  I want to be able to choose best answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:another_answer) { create(:answer, question: question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'only question owner see link' do
    expect(page).not_to have_content('это лучший ответ')
  end

  scenario 'choose best answer' do
    within ".answer##{another_answer.id}" do
      click_on 'это лучший ответ'
      expect(page).to have_content('этот ответ лучший')
    end
  end
end