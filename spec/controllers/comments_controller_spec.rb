require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "Question"
    sign_in_user_and_create_question

    describe "POST #create" do
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
    end

    describe "DETELE #destroy" do
    end
  end
