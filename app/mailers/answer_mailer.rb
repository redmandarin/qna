class AnswerMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_mailer.notify.subject
  #
  def notify(question_id)
    question = Question.find(question_id)
    @greeting = "Hi. Someone just answer to your quesiton"
    @question = question

    mail to: question.user.email
  end

  def notify_subscriber(question_id, user_id)
    @question = Question.find(question_id)
    user = User.find(user_id)
    @greeting = "Hi. there some update waiting to you"
    
    mail to: user.email
  end
end
