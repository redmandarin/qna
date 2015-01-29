class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: [:show]

  def index
    respond_with(@answers = Question.find(params[:question_id]).answers)
  end

  def show
    respond_with @answer
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end
end