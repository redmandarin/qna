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

  it "should validate user authority for quesiton" do
    user = create(:user)
    another_user = create(:user)
    question = create(:question, user_id: user.id)

    expect(question.author?(another_user)).to eq(false)
  end
end
