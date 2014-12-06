require 'rails_helper'

RSpec.describe Rating, :type => :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should belong_to :answer }
  it { should have_many :votes }

  it "should have default value 0" do
    expect(Rating.new().value).to eq(0)
  end

end
