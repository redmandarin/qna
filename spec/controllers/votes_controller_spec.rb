require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  desctibe 'POST #create' do
    context 'quesiton' do
      it 'change rating of the question by +1' do

      end

      it 'change rating by -1' do

      end
    end

    context 'answer' do
      it 'change rating of the question by +1' do

      end

      it 'change rating by -1' do

      end
    end
  end
end