require 'rails_helper'

RSpec.describe Question, :type => :model do
  subject { build(:question) }
  
  it { should belong_to :user }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :votes }
  it { should have_many :tags }
  it { should have_many :taggings }
  it { should have_many :attachments }
  it { should have_many :subscriptions }
  it { should have_many :subscribers }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  describe 'rating' do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it 'should calculate reputation after creating' do
      expect(Ratingable).to receive(:calculate)
      subject.save!
    end

    it 'should not calculate reputation after update' do
      subject.save!
      expect(Ratingable).to_not receive(:calculate)
      subject.update(title: '123')
    end

    it 'should save user reputation' do
      allow(Ratingable).to receive(:calculate).and_return(5)
      expect { subject.save! }.to change(user, :rating).by(5)
    end
  end

  describe "#author?" do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it "should return true" do
      expect(user.author?(question)).to eq(true)
    end

    it "should return false" do
      expect(another_user.author?(question)).to eq(false)
    end
  end

  describe "Tag" do
    let(:question) { create(:question) }
    let(:another_question) { create(:question) }
    let(:tag_list) { "tag1, tag2" }

    it "does not create duplication" do
      question.tag_list = tag_list
      another_question.tag_list = "tag1"

      expect(Tag.where(name: "tag1").count).to eq(1)
    end

    it "#tags_before_create" do
      question.tag_list=(tag_list)

      expect(question.tags[0].name).to eq("tag1")
      expect(question.tags[1].name).to eq("tag2")
    end

    it "#tag_list" do
      question.tag_list=(tag_list)

      expect(question.tag_list).to eq("tag1, tag2")
    end

    it ".tagged_with" do
      question = create(:question, tag_list: "tag1, tag2")

      expect(Question.tagged_with("tag1")).to match_array([question])
    end
  end
end
