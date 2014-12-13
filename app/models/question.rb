class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_one :rating, as: :rateable, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
