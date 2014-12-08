class User < ActiveRecord::Base
  validates :name, presence: true

  has_many :votes
  has_many :questions
  has_many :answers
  has_many :comments, as: :commentable
  has_one :rating, as: :rateable

end
