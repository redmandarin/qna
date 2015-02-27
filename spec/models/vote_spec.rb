require 'rails_helper'

RSpec.describe Vote, :type => :model do
  it { should belong_to :user }
  it { should belong_to :voteable }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :voteable_id }
  it { should validate_presence_of :voteable_type }
  it { should validate_presence_of :value }

  it { should ensure_inclusion_of(:value).in_array(%w(1 -1))}
  # it { should validates_uniqueness_of(:user_id) }

  describe 'rating' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    subject { build(:vote, user: create(:user), voteable: question, value: 1) }

    it 'should calculate reputaiton after creation' do
      expect(RatingService).to receive(:vote).with(subject)
      subject.save!
    end

    it 'should not calc. reputation if value not changed' do
      subject.save!
      expect(RatingService).not_to receive(:vote)
      subject.update(value: 1)
    end

    it 'should calc. reputation after update' do
      subject.save!
      expect(RatingService).to receive(:vote).with(subject)
      subject.update(value: -1)
    end
  end
end
