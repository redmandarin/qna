require 'rails_helper'

RSpec.describe Tag, :type => :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :question_id }
  it { should belong_to :question }
end
