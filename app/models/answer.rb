class Answer < ActiveRecord::Base
  include Authority
  belongs_to :question
  belongs_to :user
  has_one :rating, as: :rateable
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, :user_id, :question_id, presence: true

end
