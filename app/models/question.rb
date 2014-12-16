class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_one :rating, as: :rateable, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  def author?(user)
    unless self.user_id == user.id
      return false
    else
      return true
    end
  end
end
