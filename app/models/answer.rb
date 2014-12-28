class Answer < ActiveRecord::Base
  include Authority
  belongs_to :question
  belongs_to :user
  has_one :rating, as: :rateable
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachmentable

  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :body, :user_id, :question_id, presence: true

end
