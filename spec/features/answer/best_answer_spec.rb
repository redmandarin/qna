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

  scenario 'only question owner see link', js: true do
    expect(page).not_to have_content('это лучший ответ')
  end

  describe 'best answer exist' do
    before do
      within all(".answer").last do
        click_on 'этот ответ лучший'
      end
    end

    scenario 'choose', js: true do
      within all(".answer").last do
        expect(page).to have_content('это лучший ответ')
      end
    end
  end

  describe 'best answer exist' do
    before do
      within first(".answer") do
        click_on 'этот ответ лучший'
      end

      within all(".answer").last do
        click_on 'этот ответ лучший'
      end
    end

    scenario 're-choose', js: true do
      within first(".answer") do
        expect(page).not_to have_content('это лучший ответ')
      end

      within all(".answer").last do
        expect(page).to have_content('это лучший ответ')
      end
    end
  end
end