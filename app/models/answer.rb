class Answer < ActiveRecord::Base
  include Authority
  belongs_to :question
  belongs_to :user
  has_one :rating, as: :rateable
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachmentable

  validates :body, :user_id, :question_id, presence: true
  
  accepts_nested_attributes_for :attachments, allow_destroy: true, :reject_if => lambda { |a| a['file'].blank? }

end
