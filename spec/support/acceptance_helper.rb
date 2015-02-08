module AcceptanceHelper
  def sign_in(user)
    user.confirm!
    visit new_user_session_path
    fill_in 'Эл. почта', with: user.email
    fill_in 'Пароль', with: user.password
    click_on 'Log in'
  end

  def create_question_with_one_file
    visit new_question_path
    fill_in 'Заголовок', with: "New"
    fill_in 'Вопрос', with: "Brand New"
    fill_in 'Список тегов', with: "another1, another2"
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Сохранить вопрос'
  end

  def attach_files(type, scope)
    within type do
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

end
