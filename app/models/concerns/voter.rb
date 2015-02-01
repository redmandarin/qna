module Voter
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
end