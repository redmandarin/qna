require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:another_answer) { create(:answer, question: question) }
  let!(:another_user) { create(:user) }

  before do 
    another_user.confirm!
  end

  describe 'PATCH #mark_best' do
    context 'author' do
      before { patch :mark_best, id: answer, format: :js }
      
      it 'change answer best field' do
        answer.reload
        expect(answer.best).to eq(true)
      end

      it 'make other answers best field eq. to false' do
        expect(another_answer.best).to eq(false)
      end
    end
    
    context 'not an author' do
      sign_in_user

      it 'does not change best answer' do
        sign_out @user
        patch :mark_best, id: answer, format: :js
        answer.reload
        expect(answer.best).to eq(false)
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new answer in the database" do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not save answer" do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.not_to change(Answer, :count)
      end
    end

    context "PrivatePub" do
      it 'publish to' do
        expect(PrivatePub).to receive(:publish_to)
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
      end
    end

    context "not signed in" do
      it "redirects to sign in" do
        sign_out user
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "assigns requested answer to @answer" do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer, quesition_id: question.id), format: :js
        expect(assigns(:answer)).to eq(answer)
      end

      it "changes answer attributes" do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer, body: "brand new body", quesition_id: question.id), format: :json
        answer.reload
        expect(answer.body).to eq("brand new body")
      end

      it "200" do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer, quesition_id: question.id), format: :json
        expect(response.status).to eq(200)
      end
    end

    context "not an author" do
      it "not update question" do
        sign_out user
        sign_in another_user
        patch :update, id: answer, answer: attributes_for(:answer, body: "brand new title"), format: :json
        answer.reload

        expect(answer.body).not_to eq("brand new title")
      end

      it "redirects to question" do
        sign_out user
        sign_in another_user
        patch :update, id: answer, answer: attributes_for(:answer, body: "brand new title"), format: :json
        answer.reload

        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid attributes" do
      before { patch :update, question_id: question, id: answer, answer: { body: nil }, format: :json }

      it "does not change answer attributes" do
        answer.reload
        expect(answer.body).to eq("My answer text")
      end
    end

    context "not signed in" do
      it "redirects to sign in" do
        sign_out user
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer, body: "brand new title", quesition_id: question.id)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
