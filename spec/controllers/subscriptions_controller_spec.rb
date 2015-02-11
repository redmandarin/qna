require 'rails_helper'

RSpec.describe SubscriptionsController, :type => :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe '#POST' do
    sign_in_user

    it 'saves new subscription in the database' do
      expect { post :create, subscription: { question_id: question.id }, format: :js }.to change(question.subscribers, :count).by(1)
    end
  end
end
