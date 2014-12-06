require 'rails_helper'

RSpec.describe Vote, :type => :model do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :rating_id }
  it { should validate_presence_of :value }
  it { should belong_to :user }
  it { should belong_to :rating }
end
