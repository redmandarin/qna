class AnswerMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_mailer.notify.subject
  #
  def notify(question)
    @greeting = "Hi. Someone just answer for your quesiton"
    @question = question

    mail to: question.user.email
  end

  def notify_subscriber(question, user)
    @greeting = "Hi. there some update waiting to you"
    @question = question
    
    mail to: user.email
  end
end
