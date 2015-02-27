# Class for models: Vote, Answer
class RatingService
  def self.make_answer(answer)
    case answer.question.answers.count
    when 1
      increment_by = answer.user == answer.question.user ? 3 : 1
    when 2
      increment_by = 2
    else
      increment_by = 1
    end
    answer.user.increment(:rating, increment_by)
  end

  def self.calculate(user)
    # sleep(3)
  end

  def self.vote(vote)
    user = vote.voteable.user
    voteable = vote.voteable

    user_rating_inc = vote.voteable_type == 'Question' ? vote.value * 2 : vote.value
    rating = voteable.votes.where(value: 1).count - voteable.votes.where(value: -1).count

    voteable.update(rating: rating)
    user.increment!(:rating, user_rating_inc)
  end

  def self.best_answer(answer)
    answer.user.increment!(:rating, 3)
  end
end