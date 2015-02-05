class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update]
  before_action :set_question, only: [:create]
  after_action :publish_answer, only: :create

  respond_to :json, :js

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer do |format|
      format.json { render json: @answer.to_json(include: :attachments) }
    end
  end

  def mark_best
    @answer = Answer.find(params[:id])
    @answer.mark_best if @answer.save
    respond_with @answer
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: AnswerSerializer.new(@answer, root: false) if @answer.valid?
  end

  def answer_params
    params.require(:answer).permit(:body, :mark_best, attachments_attributes: [:file, :_destroy])
  end
end
