module Ratingable
  extend ActiveSupport::Concern

  def self.make_answer(answer)
    case answer.question.answers.count
    when 1
      if answer.user == answer.question.user
        increment_by = 3
      else
        increment_by = 1
      end
    when 2
      increment_by = 2
    end
    answer.user.increment(:rating, increment_by)
  end

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
    voteable.update(rating: rating)
    user.increment!(:rating, user_rating_inc)
  end

  def self.best_answer(answer)
    answer.user.increment!(:rating, 3)
  end
end
