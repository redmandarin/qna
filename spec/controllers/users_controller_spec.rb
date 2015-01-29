require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET show' do
    before do
      get :show, id: user
    end

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET index' do
    let(:users) { create_list(:user, 2) }
    before do
      get :index
    end

    it 'populates an array of all users' do
      expect(assigns(:users)).to match_array(users)
    end
  end
end