require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: @user) }
  let!(:another_question) { create(:question) }

  describe "GET #index" do 
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions << another_question)
    end

    it "renders index view" do
      expect(response).to render_template(:index)
    end

    it "show questions by tag" do
      question1 = create(:question, tag_list: "tag1, tag2")
      question2 = create(:question, tag_list: "tag1")
      get :index, tag: "tag1"

      expect(assigns(:questions)).to match_array([question1, question2])
    end
  end

  describe "GET #show" do
    before { get :show, id: another_question }
    
    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq(another_question)
    end

    it "renders show view" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    sign_in_user
    before { get :new }

    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "renders new view" do
      expect(response).to render_template(:new)
    end

    context "not signed in" do
      it "redirects to sign_in" do
        sign_out @user
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    sign_in_user_and_create_question
    before { get :edit, id: @question }


    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq(@question)
    end

    it "renders edit view" do
      expect(response).to render_template(:edit)
    end

    context "non-author" do
      it "should not be able to edit question" do
        get :edit, id: another_question

        expect(response).to redirect_to(question_path(another_question))
      end
    end

    context "not signed in" do
      it "redirects to sign_in" do
        sign_out @user
        get :edit, id: another_question 
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    sign_in_user
    context "with valid attributes" do
      it "saves the new question in the database" do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      # it "saves with tags" do
      #   post :create, question: attributes_for(:question, tag_list: "tag1, tag2")
      #   expect(assigns(:question).tags[0].name).to eq(tag1)
      #   expect(assigns(:question).tags[1].name).to eq(tag2)
      # end

      it "redirects to show view" do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to(question_path(assigns(:question)))
      end
    end

    context "with invalid attributes" do
      it "does not save the question" do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it "re-render new view" do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template(:new)
      end
    end

    context "not signed in" do
      it "redirects to sign_in" do
        sign_out @user
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #update" do
    sign_in_user
    context "valid attributes" do
      it "assigns the requested question to @question" do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq(question)
      end

      it "changes question attributes" do
        patch :update, id: question, question: { title: "new title", body: "new body" }
        question.reload
        expect(question.title).to eq("new title")
        expect(question.body).to eq("new body")
      end

      it "redirects to the updates question" do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to(question)
      end
    end

    context "not author" do
      it "should not be able to #update question" do
        another_user = create(:user)
        sign_in another_user
        patch :update, id: question, question: { title: "new title", body: "new body" }
        question.reload
        expect(question.title).not_to eq("new title")
        expect(question.body).not_to eq("new body")
      end
    end

    context "invalid attributes" do
      before { patch :update, id: question, question: { title: "new title", body: nil } }
      
      it "does not change question attributes" do
        question.reload
        expect(question.title).to eq("MyString")
        expect(question.body).to eq("MyText")
      end

      it "re-render edit view" do
        expect(response).to render_template(:edit)
      end
    end

    context "not signed in" do
      it "redirects to sign_in" do
        sign_out @user
        patch :update, id: question, question: { title: "new title", body: "new body" }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user
    before { question }

    it "delete question" do
      expect { delete :destroy, id: question}.to change(Question, :count).by(-1)
    end

    it "can't delete question as not author" do
      expect { delete :destroy, id: another_question }.not_to change(Question, :count)
    end

    it "redirects to index view" do
      delete :destroy, id: question
      expect(response).to redirect_to(questions_path)
    end

    context "not signed in" do
      it "redirects to sign_in" do
        sign_out @user
        delete :destroy, id: question
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
