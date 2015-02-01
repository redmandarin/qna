require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should belong_to :user }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :votes }
  it { should have_many :tags }
  it { should have_many :taggings }
  it { should have_many :attachments }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

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

  describe '#vote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    # let(:vote) { create(:vote) }

    it 'should change rating of question by 1' do
      expect { question.vote(1) }.to change(question, :rating).by(1)
    end
    
    it 'should change rating of question by -1' do
      expect { question.vote(-1) }.to change(question, :rating).by(-1)
    end

    it 'should change rating of user by 1' do
      expect { question.vote(1) }.to change(question.user, :rating).by(1)
    end

    it 'should change rating of user by -1' do
      expect { question.vote(-1) }.to change(question.user, :rating).by(-1)
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
