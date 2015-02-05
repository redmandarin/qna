module Ratingable
  extend ActiveSupport::Concern

  def self.calculate
  end

  def self.vote(vote)
    user = vote.voteable.user
    case vote.voteable_type
    when 'Question'
      user.rating += vote.value.to_i * 2
    when 'Answer'
      user.rating += vote.value.to_i
    end
    user.save
  end

  def self.best_answer(answer)
    answer.user.rating += 3
    answer.user.save
  end
end