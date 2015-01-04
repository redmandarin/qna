require 'rails_helper'

RSpec.describe AttachmentsController, :type => :controller do

  let(:question) { create(:question_with_file, user: @user) }
  let(:another_user) { create(:user) }

  describe "DELETE" do
    sign_in_user
    before do
      question
    end
    it "can delete as authenticated user" do
      delete :destroy, id: question.attachments.first, format: :json
      expect(response.status).to eq(200)
    end

    it "can't delete as no author" do
      sign_out @user
      sign_in(another_user)
      delete :destroy, id: question.attachments.first, format: :json
      expect(response.status).to eq(401)
    end

    it "can't delete as guest" do
      sign_out @user
      delete :destroy, id: question.attachments.first, format: :json
      expect(response.status).to eq(401)
    end
  end
end
