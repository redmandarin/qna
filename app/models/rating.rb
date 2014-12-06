class Rating < ActiveRecord::Base
  validates :model_id, :model_name, presence: true

  belongs_to :user, foreign_key: "model_id"
  belongs_to :question, foreign_key: "model_id"
  belongs_to :answer, foreign_key: "model_id"
  has_many :votes

end
