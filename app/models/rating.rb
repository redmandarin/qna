class Rating < ActiveRecord::Base
  validates :model_id, :model_name, presence: true

  belongs_to :user
  belongs_to :question
  belongs_to :answer
  has_many :votes

end
