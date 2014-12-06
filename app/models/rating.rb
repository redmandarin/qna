class Rating < ActiveRecord::Base
  validates :model_id, :model_name, :user_id, presence: true

  belongs_to :user
  belongs_to :question
  belongs_to :answer
end
