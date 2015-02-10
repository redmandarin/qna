module Ratingable
  extend ActiveSupport::Concern

  def self.calculate(user)
    # sleep(3)
  end

  def self.vote(vote)
    user = vote.voteable.user
    voteable = vote.voteable
    case vote.voteable_type
    when 'Question'
      user_rating_inc = vote.value.to_i * 2
    when 'Answer'
      user_rating_inc = vote.value.to_i
    end
    rating = voteable.votes.where(value: 1).count - voteable.votes.where(value: -1).count
    voteable.increment!(:rating, rating)
    user.increment!(:rating, user_rating_inc)
  end

  def self.best_answer(answer)
    answer.user.increment!(:rating, 3)
  end
end
