require 'rails_helper'

RSpec.describe DailyDigestWorker, type: :model do

  describe 'daily disest' do
    before do
      now = Time.now.utc
      allow(Time).to receive(:now) { now }
    end

    it 'should send daily digest' do
      expect(User).to receive(:send_daily_digest)
      subject.perform
    end
  end
end
