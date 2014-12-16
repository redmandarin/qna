require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_one :rating }
  it { should have_many :comments }

  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }

  it "check author? with given user" do
    user = create(:user)
    another_user = create(:user)
    question = create(:question, user: user)
    answer = create(:answer, question: question, user: user)

    expect(answer.author?(another_user)).to eq(false)
    expect(answer.author?(user)).to eq(true)
  end
end
