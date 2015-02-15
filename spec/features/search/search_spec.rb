require_relative '../feature_helper'

feature 'search', %q{
	In order to find things
	As user
	I want to be able to find things
} do

	given!(:question) { create(:question, body: "Very important question") }
	given!(:answer) { create(:answer, body: "Very important answer") }
	given!(:comment) { create(:comment, body: "Very important comment") }

	scenario 'search through all', js: true do
		create(:question, body: "Very important question")
		# system('rake RAILS_ENV=test ts:index')
		# system('rake RAILS_ENV=test ts:start')
		ThinkingSphinx::Test.index
	  ThinkingSphinx::Test.run do
			sleep(1)
	    visit root_path
			within ".search" do
				fill_in "q", with: 'important'
				click_on 'Поиск'
			end
			expect(page).to have_content('Very important question')
			expect(page).to have_content('Very important answer')
			expect(page).to have_content('Very important comment')
		end
	end
end