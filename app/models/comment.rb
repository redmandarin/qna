class Comment < ActiveRecord::Base
  validates :body, :question_id, :user_id, presence: true

  belongs_to :commentable, polymorphic: true
end
