module Voteable
  extend ActiveSupport::Concern

  def vote(value)
    self.rating += value.to_i
    case self.class.name
    when 'Question'
      self.user.rating += value.to_i * 2
    when 'Answer'
      self.user.rating += value.to_i
    end
    self.user.save
    self.save
  end

  def mark_best
    self.question.answers.where.not(id: self.id).update_all(best: false)
    self.user.rating += 3
    self.user.save
  end
end