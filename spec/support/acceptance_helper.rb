module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Эл. почта', with: user.email
    fill_in 'Пароль', with: user.password
    click_on 'Log in'
  end

  def attach_files(scope)
    all(scope).each do |field|
      if all(scope).index(field) == 0
        within(field) do
          attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
        end
      else
        within(field) do
          attach_file 'Файл', "#{Rails.root}/spec/rails_helper.rb"
        end
      end
    end
  end
  
end