class Answer < ActiveRecord::Base
  include Authority
  
  belongs_to :question, touch: true
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  has_many :attachments, as: :attachmentable

  validates :body, :user_id, :question_id, presence: true
  
  accepts_nested_attributes_for :attachments, allow_destroy: true, :reject_if => lambda { |a| a['file'].blank? }

  after_create :calculate_reputation
  after_create :send_notification
  after_create :notify_subscribers

  scope :ordered, -> { order("best DESC") }
  
  def mark_best
    self.update(best: true)
    self.question.answers.where.not(id: self.id).update_all(best: false)
    RatingService.best_answer(self)
  end

  private

  def calculate_reputation
    RatingService.delay.make_answer(self)
  end

  def send_notification
    AnswerMailer.delay.notify(self.question.id)
  end

  def notify_subscribers
    self.question.subscribers.find_each.each do |user|
      AnswerMailer.delay.notify_subscriber(self.question.id, user.id)
    end
  end
end
