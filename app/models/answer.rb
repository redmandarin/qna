class Answer < ActiveRecord::Base
  include Authority
  
  belongs_to :question
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  has_many :attachments, as: :attachmentable

  validates :body, :user_id, :question_id, presence: true
  
  accepts_nested_attributes_for :attachments, allow_destroy: true, :reject_if => lambda { |a| a['file'].blank? }

  after_create :calculate_reputation

  def mark_best
    self.update(best: true)
    self.question.answers.where.not(id: self.id).update_all(best: false)
    Ratingable.best_answer(self)
  end

  private

  def calculate_reputation
    Ratingable.calculate(self)
  end
end
