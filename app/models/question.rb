class Question < ActiveRecord::Base
  validates :title, :body, presence: true

  has_many :answers
  has_many :comments, as: :commentable
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user
  has_one :rating, as: :rateable

end
