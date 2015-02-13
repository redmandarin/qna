require 'rails_helper'

RSpec.describe SearchController, :type => :controller do

  describe 'GET search' do
    let!(:question) { create(:question, title: "Very inmportant body.") }

    it 'has three objects in array' do
      get :index, q: 'important'
      expect(response).to render_template :index
    end
  end
end
