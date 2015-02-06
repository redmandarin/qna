module Ratingable
  extend ActiveSupport::Concern

  def self.calculate
  end

  def self.vote(vote)
    user = User.find(vote.voteable.user.id)
    # puts user.to_json
    case vote.voteable_type
    when 'Question'
      user.rating += vote.value.to_i * 2
    when 'Answer'
      user.rating += vote.value.to_i
    end
    vote.voteable.rating = vote.voteable.votes.where(value: 1).count - vote.voteable.votes.where(value: -1).count
    vote.voteable.save
    user.save
  end

  def self.best_answer(answer)
    answer.user.rating += 3
    answer.user.save
  end
end