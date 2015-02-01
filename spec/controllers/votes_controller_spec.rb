require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:vote) { create(:vote, value: 1) }

  describe 'POST #create' do
    sign_in_user
    
    context 'question' do
      it 'change rating of the question by +1' do
        post :create, vote: { value: 1 }, question_id: question, format: :js
        question.reload
        expect(question.rating).to eq(1)
      end

      it 'change rating by -1' do
        post :create, vote: { value: -1 }, question_id: question, format: :js
        question.reload
        expect(question.rating).to eq(-1)
      end

      it 'creates vote' do
        expect { post :create, vote: { value: 1 }, question_id: question, format: :js }.to change(Vote, :count).by(1)
      end

      it 'user can not create vote for the question two times' do
        post :create, vote: { value: -1 }, question_id: question, format: :js
        expect { post :create, vote: { value: -1 }, question_id: question, format: :js }.not_to change(Vote, :count)
      end

      it 'user can not vote save value two times' do
        post :create, vote: { value: -1 }, question_id: question, format: :js
        post :create, vote: { value: -1 }, question_id: question, format: :js
        question.reload
        expect(question.rating).to eq(-1)
      end
    end

    context 'answer' do
      it 'change rating of the question by +1' do
        post :create, vote: { value: 1 }, answer_id: answer, format: :js
        answer.reload
        expect(answer.rating).to eq(1)
      end

      it 'change rating by -1' do
        post :create, vote: { value: -1 }, answer_id: answer, format: :js
        answer.reload
        expect(answer.rating).to eq(-1)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:question) { create(:question, rating: 1)}
    let!(:vote) { create(:vote, voteable: question, value: 1) }
    let!(:another_question) { create(:question, rating: -1)}
    let!(:another_vote) { create(:vote, voteable: another_question, value: -1) }

    it 'response should be success' do
      pacth :update, id: another_vote, vote: { value: 1 }, format: :js
      expect(response).to be_success
    end

    it 'change rating of the question by +1' do
      patch :update, id: another_vote, vote: { value: 1 }, format: :js
      another_question.reload
      expect(another_question.rating).to eq(0)
    end

    it 'change rating of the question by -1' do
      patch :update, vote: { value: -1 }, id: vote, format: :js
      question.reload
      expect(question.rating).to eq(0)
    end

    it 'can not change by +2' do
      put :update, id: vote, vote: { value: 1 }, format: :js
      question.reload
      expect(question.rating).to eq(1)
    end

    it 'change value of vote from 1 to -1' do
      patch :update, vote: { value: -1 }, id: vote, format: :js
      vote.reload
      expect(vote.value).to eq(-1)
    end

    it 'does not change votes count' do
      expect { patch :update, vote: { value: -1 }, id: vote, format: :js }.not_to change(Vote, :count)
    end
  end
end