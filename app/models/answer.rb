class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_one :rating, as: :rateable
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true
end
