require 'rails_helper'

RSpec.describe Rating, :type => :model do
  it { should validate_presence_of :model_id }
  it { should validate_presence_of :model_name }
  it { should validate_presence_of :user_id }
  it { should belong_to :user }
  it { should belong_to :question }
  it { should belong_to :answer }
  it { should have_many :votes }

  it "should have default value 0" do
    expect(Rating.new().value).to eq(0)
  end

end
