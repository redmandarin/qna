class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update]
  before_action :set_question
  before_action :authorize, only: [:edit, :update]

  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def authorize
    unless @answer.author?(current_user)
      redirect_to question_path(@question)
      flash[:alert] = "У вас нехватает прав для выполнения этого действия."
    end
  end
end
