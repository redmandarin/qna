class Tag < ActiveRecord::Base
  validates :name, :question_id, presence: true

  belongs_to :question
end
