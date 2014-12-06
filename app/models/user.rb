class User < ActiveRecord::Base
  validates :name, presence: true

  has_many :votes
  has_many :questions
  has_many :answers
  has_many :comments
  has_one :rating

end
