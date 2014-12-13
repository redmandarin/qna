require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question_id: question.id) }

  describe "GET #new" do
    before { get :new, question_id: question }

    it "assigns new answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end


    it "renders new view" do
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    before { get :edit, question_id: question, id: answer }

    it "assigns the requested answer to @answer" do
      expect(assigns(:answer)).to eq(answer)
    end

    it "renders edit view" do
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new answer in the database" do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count)
      end

      it "redirect to question path" do
        post :create, question_id: question, answer: attributes_for(:answer, question_id: question.id)
        expect(response).to redirect_to(question_path(question))
      end
    end

    context "with invalid attributes" do
      it "does not save answer" do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.not_to change(Answer, :count)
      end

      it "re-render new view" do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "assigns requested answer to @answer" do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer, quesition_id: question.id)
        expect(assigns(:answer)).to eq(answer)
      end

      it "changes answer attributes" do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer, body: "brand new title", quesition_id: question.id)
        answer.reload
        expect(answer.body).to eq("brand new title")
      end

      it "redirects to parent question vies" do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer, quesition_id: question.id)
        expect(response).to redirect_to(question_path(question))
      end
    end

    context "with invalid attributes" do
      before { patch :update, question_id: question, id: answer, answer: { body: nil } }

      it "does not change answer attributes" do
        answer.reload
        expect(answer.body).to eq("MyText")
      end

      it "re-render edit view" do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    before { answer }

    it "delete answer" do
      expect { delete :destroy, question_id: question, id: answer }.to change(Answer, :count).by(-1)
    end

    it "redirects to parent question view" do
      delete :destroy, question_id: question, id: answer
      expect(response).to redirect_to(question_path(question))
    end
  end
end
