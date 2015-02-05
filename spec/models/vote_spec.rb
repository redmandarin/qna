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
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    subject { build(:vote, user: user, voteable: question) }

    it 'should calculate reputaiton after creation' do
      expect(Ratingable).to receive(:vote)
      subject.save!
    end

    it 'should calc. reputation after update' do
      subject.save!
      expect(Ratingable).to receive(:vote).with(:vote)
      subject.update(value: -1)
    end
  end
end
