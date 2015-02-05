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
    subject { build(:vote, user: create(:user), voteable: question, value: 1) }
    let(:user) { create(:user, rating: 0) }
    let(:question) { create(:question, user: user) }

    it 'should calculate reputaiton after creation' do
      expect(Ratingable).to receive(:vote).with(subject)
      subject.save!
    end

    it 'should not calc. reputation if value not changed' do
      expect(Ratingable).to receive(:vote).with(subject) # ?
      subject.save!
      expect(Ratingable).not_to receive(:vote)
      subject.update(value: 1)
    end

    it 'should calc. reputation after update' do
      expect(Ratingable).to receive(:vote).with(subject) # ?
      subject.save!
      expect(Ratingable).to receive(:vote).with(subject)
      subject.update(value: -1)
    end
  end
end
