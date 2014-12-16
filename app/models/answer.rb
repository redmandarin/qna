class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_one :rating, as: :rateable
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, :user_id, :question_id, presence: true

  def author?(user)
    if self.user_id == user.id
      return true
    else
      return false
    end
  end
end
