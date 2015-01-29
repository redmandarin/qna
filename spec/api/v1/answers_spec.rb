require 'rails_helper'

describe 'Answer API' do
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }

  describe 'GET /' do
    context 'unauthorized' do
      it 'returns 401 if there no access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '123456'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'response shoul be success' do
        expect(response).to be_success
      end

      it 'return list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "contain #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /:id' do
    context 'authorized' do
      let(:answer) { create(:answer, question: question) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'respond should be success' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contain #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end
  end
end