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

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe "#mark_best" do
    it 'add +3 points' do
      answer.mark_best
      expect(answer.user.rating).to eq(3)
    end
  end

  describe "#author?" do

    it "should return true" do
      puts "hello"
      puts answer.id
      expect(user.author?(answer)).to eq(true)
    end

    it "should return false" do
      expect(another_user.author?(answer)).to eq(false)
    end
  end
end
