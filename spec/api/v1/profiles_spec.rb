require 'rails_helper'

describe 'Profile API' do

  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("user/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).not_to have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:user) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: user.id)}

      before { get '/api/v1/profiles', access_token: access_token.token, format: :json }

      it 'returns 200' do
        puts response.body
        expect(response).to be_success
      end

      it 'rerurns list of users' do
        expect(response.body).to have_json_size(2).at_path("profiles")
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(users[1].send(attr.to_sym).to_json).at_path("profiles/0/#{attr}")
        end
      end
    end
  end


  def do_request(options = {})
    get 'api/v1/questions', { format: :json }.merge(options)
  end
end