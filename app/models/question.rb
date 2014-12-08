class Question < ActiveRecord::Base
  validates :title, :body, presence: true

  has_many :answers
  has_many :comments, as: :commentable
  belongs_to :user
  has_one :rating, as: :rateable

end
