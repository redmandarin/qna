class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update]
  before_action :set_question, only: [:create]
  before_action :authorize, only: [:edit, :update]
  after_action :publish_answer, only: :create

  respond_to :json, :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer do |format|
      format.json { render json: @answer.to_json(include: :attachments) }
    end

    # respond_to do |format|
    #   if @answer.update(answer_params)
    #     format.json { render json: @answer.to_json(include: :attachments) }
    #   else
    #     format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
    #   end
    # end
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
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy])
  end

  def authorize
    unless current_user.author?(@answer)
      redirect_to questions_path
      flash[:alert] = "У вас нехватает прав для выполнения этого действия."
    end
  end
end
