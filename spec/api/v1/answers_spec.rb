require 'rails_helper'

describe 'Answer API' do
  let!(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
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
      let!(:attachment) { create(:attachment, attachmentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'respond should be success' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contain #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'attachments' do

        it 'contain filename' do
          expect(response.body).to be_json_eql(attachment.file.file.filename.to_json).at_path("answer/attachments/0/filename")
        end

        it 'contain url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /' do
    context 'authorized' do
      context 'invalid attributes' do
        it 'returns 422' do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer, body: nil), format: :json, access_token: access_token.token
          expect(response.status).to eq(422)
        end

        it 'does not save the answer' do
          expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer, body: nil), format: :json, access_token: access_token.token }.not_to change(question.answers, :count)
        end
      end

      context 'valid attributes' do
        it 'returns 201' do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token
          expect(response.status).to eq(201)
        end

        it 'save the answer' do
          expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token }.to change(question.answers, :count).by(1)
        end

        it 'returns json answer'
      end
    end
  end
end