require 'rails_helper'

RSpec.describe Tag, :type => :model do
  it { should have_many :questions }
  it { should have_many :taggings }
  
  it { should validate_presence_of :name }
end
