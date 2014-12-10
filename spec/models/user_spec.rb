require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :votes }
  it { should have_one :rating }

  it { should validate_presence_of :name }
end
