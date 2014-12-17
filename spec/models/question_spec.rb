require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should belong_to :user }
  it { should have_one :rating }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :tags }
  it { should have_many :taggings }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  describe "#author?" do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it "should return true" do
      expect(question.author?(user)).to eq(true)
    end

    it "should return false" do
      expect(question.author?(another_user)).to eq(false)
    end
  end
end
