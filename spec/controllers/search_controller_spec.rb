require 'rails_helper'

RSpec.describe SearchController, :type => :controller do

  describe 'GET search' do
    let!(:question) { create(:question, title: "Very inmportant body.") }

    it 'has three objects in array' do
      get :index, q: 'important'
      expect(response).to render_template :index
    end

    it 'search in questions' do
      expect(Question).to receive(:search)
      get :index, q: 'some', scope: 'question'
    end

    it 'search in answers' do
      expect(Answer).to receive(:search)
      get :index, q: 'some', scope: 'answer'
    end

    it 'search in comments' do
      expect(Comment).to receive(:search)
      get :index, q: 'some', scope: 'comment'
    end
  end
end
