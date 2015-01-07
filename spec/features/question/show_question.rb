require_relative "../feature_helper"

feature "show question with comments" do
  given(:question) { create(:question_with_comment) }

  scenario "show comments" do
    visit question_path(question)

    expect(page).to have_content("Comment text")
  end
end