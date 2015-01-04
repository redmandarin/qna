require_relative '../feature_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when he ask question', js: true do
    fill_in 'Ответ', with: 'Test answer'
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Сохранить ответ'
    
    within '.answers' do
      expect(page).to have_link('spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb')
    end
  end

  scenario 'User adds multiple files', js: true do
    fill_in 'Ответ', with: "Some text"
    within '.new_answer' do
      click_on "Добавить файл"
    end
    attach_files(".new_answer", ".fields")
    click_on 'Сохранить ответ'
    
    expect(page).to have_link('spec_helper.rb')
    expect(page).to have_link('rails_helper.rb')
  end
end