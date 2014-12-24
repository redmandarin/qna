require_relative '../feature_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when he ask question' do
    fill_in 'Заголовок', with: 'Test question'
    fill_in 'Вопрос', with: 'Тело вопроса'
    fill_in 'Список тегов', with: 'tag1, tag2'
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Сохранить вопрос'

    expect(page).to have_content('spec_helper.rb')
    
  end
end