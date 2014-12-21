# require 'rails_helper'

# feature "User answer", %q{
#   In order to commenting questions and answers
#   As User
#   I want to be able to create comments
# } do

#   given(:question) { create(:question) }
#   given(:user) { create(:user) }

#   scenario "create comment with valid attributes" do
#     sign_in(user)

#     visit(question_path(question))

#     fill_in 'Комментарий', with: "Some words"
#     click_on('Создать комментарий')

#     expect(page).to have_content("Some words")
#     expect(page).to have_content(user.name)
#   end

#   scenario "not signed_in user try to create comment" do
#     question
#     visit(question_path(question))

#     expect(page).not_to have_content("Создать комментарий")
#   end
# end