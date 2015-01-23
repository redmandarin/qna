require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let(:user) { create(:user) }

  describe "POST create" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context 'with session provider' do
      it 'creates new user' do
        session[:oauth_provider] = "new_provider"
        session[:oauth_uid] = '123456'

        expect { post :create, user: { email: "new@mail.com" } }.to change(User, :count).by(1)
      end
    end

    context 'without session provider and uid' do
      it 'does not create user' do
        expect { post :create, user: { email: "new@mail.com" } }.not_to change(User, :count)
      end
    end
  end
end