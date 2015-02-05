require 'rails_helper'

describe 'Answer API' do
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }

  describe 'GET /questions' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it_behaves_like 'Success response'

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

  describe 'GET /questions/:id' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:answer) { create(:answer, question: question) }
      let!(:attachment) { create(:attachment, attachmentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'Success response'

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

  describe 'POST /questions' do
    it_behaves_like 'API Authenticable'
    
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

  def do_request(options = {})
    get "api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
  end
end