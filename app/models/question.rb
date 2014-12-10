class Question < ActiveRecord::Base
  has_many :answers
  has_many :comments, as: :commentable
  has_many :taggings
  has_many :tags, through: :taggings
  has_one :rating, as: :rateable
  belongs_to :user

  validates :title, :body, presence: true
end
