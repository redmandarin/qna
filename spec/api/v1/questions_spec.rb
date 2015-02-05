require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  describe 'GET /questions' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it_behaves_like 'Success response'

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contain #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question contain short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do

        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contain #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /:id' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'Success response'

      %w(id title body created_at updated_at).each do |attr|
        it "contain #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end
  end

  describe "POST /questions" do
    it_behaves_like "API Authenticable"
    
    context 'authorized' do
      context 'invalid attributes' do
        # before { post '/api/v1/questions', attributes_for(:question, body: nil), format: :json }
        
        it 'returns unprocesseble entity' do
          post '/api/v1/questions', question: attributes_for(:question, body: nil), format: :json, access_token: access_token.token
          expect(response.status).to eq(422)
        end

        it 'does not save question' do
          expect { post '/api/v1/questions', question: attributes_for(:question, body: nil), format: :json, access_token: access_token.token }.not_to change(Question, :count)
        end
      end

      context 'valid attributes' do
        # before { post '/api/v1/questions', attributes_for(:question), format: :json }

        it 'creates new question' do
          expect { post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token }.to change(Question, :count).by(1)
        end

        it 'should be success' do
          post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
          expect(response.status).to eq(201)
        end

        it 'return json question'
      end
    end
  end

  def do_request(options = {})
    get 'api/v1/questions', { format: :json }.merge(options)
  end
end