require_relative "../feature_helper"

feature 'User sign out', %q{
  In order to be able close working session
  As an User
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in user

    click_on 'выйти'
    expect(page).to have_content('Выход из системы выполнен.')
    expect(current_path).to eq(root_path)
  end

end