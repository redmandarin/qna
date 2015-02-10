require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :comments }
  it { should have_many :votes }
  it { should have_many :attachments }

  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }

  it { should accept_nested_attributes_for :attachments }

  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:answer) { create(:answer, question: question, user: another_user) }

  describe "#mark_best" do
    let!(:best_answer) { create(:answer, question: question, best: true) }

    before do
      answer.mark_best
    end

    it 'make answer the best' do
      expect(answer.best).to eq(true)
    end

    it 'change other answers field to false' do
      best_answer.reload
      expect(best_answer.best).to eq(false)
    end
  end

  describe 'calc reputaiton' do
    subject { build(:answer, user: user) }

    it 'not calculate reputation if not #mark_best' do
      subject.save!
      expect(Ratingable).not_to receive(:best_answer)
      subject.update(body: '123')
    end
  end

  describe "#author?" do
    it "should return true" do
      expect(another_user.author?(answer)).to eq(true)
    end

    it "should return false" do
      expect(user.author?(answer)).to eq(false)
    end
  end

  describe 'rating' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    subject { build(:answer, question: question, user: user) }

    it 'should calculate reputation after creating' do
      expect(Ratingable).to receive(:calculate).with(subject)
      subject.save!
    end

    it 'should not calculate reputation after update' do
      subject.save!
      expect(Ratingable).to_not receive(:calculate)
      subject.update(body: '123')
    end
  end

  describe 'deliver' do
    subject { build(:answer) }

    it 'notify the creator of question' do
      expect(AnswerMailer).to receive(:notify).with(subject.question).and_call_original
      subject.save!
    end 
  end
end
