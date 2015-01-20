require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let!(:question) { create(:question_with_comment) }
  let!(:answer) { create(:answer) }
  let(:anothor_user) { create(:user) }

  describe "Question"
    sign_in_user_and_create_question

    describe "POST #create" do
      it "load question if parent is question" do
        post :create, comment: attributes_for(:comment), question_id: @question, format: :json
        expect(assigns(:target)).to eq(@question)
      end

      it "load answer if parent is answer" do
        post :create, comment: attributes_for(:comment), answer_id: answer, format: :json
        expect(assigns(:target)).to eq(answer)
      end

      it "saves comment with valid attributes" do
        expect { post :create, question_id: @question, comment: { body: "Some body" }, format: :json}.to change(@question.comments, :count).by(1)
      end

      it "does not save invalid comment" do
        expect { post :create, question_id: @question, comment: { body: nil }, format: :json}.not_to change(@question.comments, :count)
      end

      it "not save if not authenticated" do 
        sign_out @user
        expect { post :create, question_id: @question, comment: { body: "Some body"}, format: :json}.not_to change(@question.comments, :count)
      end
    end

    describe "PATCH #update" do
      it "update comment with valid attributes" do
        patch :update, question_id: @question, id: @comment, comment: { body: "New body" }, format: :json
        @comment.reload
        expect(@comment.body).to eq("New body")
      end

      it "does not update with invalid attributes" do
        patch :update, question_id: @question, id: @comment, comment: { body: "" }, format: :json
        expect(response.status).to eq(422)
      end

      it "not author can't update comment" do
        sign_out @user
        sign_in anothor_user
        patch :update, question_id: @question, id: @comment, comment: { body: "Body" }, format: :json
        expect(response.status).to eq(302)
        expect(response).to redirect_to(questions_path)
      end
    end

    describe "DETELE #destroy" do
      it "author destroy comment" do
        expect { delete :destroy, question_id: @question, id: @comment, format: :json }.to change(Comment, :count).by(-1)
      end

      it "not author can't destroy comment" do
        sign_out @user
        sign_in anothor_user
        expect { delete :destroy, question_id: @question, id: @comment, format: :json }.not_to change(Comment, :count)
      end
    end
  end
