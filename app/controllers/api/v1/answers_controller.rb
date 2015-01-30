class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: [:show]

  def index
    respond_with(@answers = Question.find(params[:question_id]).answers)
  end

  def show
    respond_with @answer
  end

  def create
    question = Question.find(params[:question_id])
    respond_with(@answer = question.answers.create(answer_params.merge(user: current_resource_owner)))
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end