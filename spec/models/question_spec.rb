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
end
