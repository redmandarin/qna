require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:vote) { create(:vote, value: 1, voteable: question) }

  before { user.update(rating: 0) } # ? Создается без rating: 0

  describe 'POST #create' do
    sign_in_user
    
    context 'question' do
      it 'creates vote' do
        # puts user.to_json
        # puts create(:user).to_json
        expect { post :create, vote: { value: 1 }, question_id: question, format: :js }.to change(question.votes, :count).by(1)
      end

      it 'user can not create vote for the question two times' do
        post :create, vote: { value: -1 }, question_id: question, format: :js
        expect { post :create, vote: { value: -1 }, question_id: question, format: :js }.not_to change(question.votes, :count)
      end
    end

    context 'answer' do
      it 'creates vote' do
        expect { post :create, vote: { value: 1 }, answer_id: answer, format: :js }.to change(answer.votes, :count).by(1)
      end

      it 'user can not create vote for two times' do
        post :create, vote: { value: -1 }, answer_id: answer, format: :js
        expect { post :create, vote: { value: -1 }, answer_id: answer, format: :js }.not_to change(answer.votes, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    it 'response should be success' do
      patch :update, id: vote, vote: { value: 1 }, format: :js
      expect(response).to be_success
    end

    it 'change value of vote from 1 to -1' do
      patch :update, vote: { value: -1 }, id: vote, format: :js
      vote.reload
      expect(vote.value).to eq(-1)
    end

    it 'does not change votes count' do
      vote
      expect { patch :update, vote: { value: -1 }, id: vote, format: :js }.not_to change(question.votes, :count)
    end
  end
end