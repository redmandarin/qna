class Question < ActiveRecord::Base
  validates :title, :body, presence: true

  has_many :answers
  has_many :comments
  belongs_to :user
  has_one :rating

end
