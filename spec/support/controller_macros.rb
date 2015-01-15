module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end

  def sign_in_user_and_create_question
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @question = create(:question, user_id: @user.id)
      @comment = create(:comment, user_id: @user.id, commentable_id: @question.id, commentable_type: "question")
      sign_in @user
    end
  end
end