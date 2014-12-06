class Comment < ActiveRecord::Base
  validates :body, :question_id, :user_id, presence: true
end
