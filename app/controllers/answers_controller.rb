class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update]
  before_action :set_question
  before_action :authorize, only: [:edit, :update]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    respond_to do |format|
      if @answer.save
        format.js do
          PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json
          render nothing: true
        end
      else
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.json { render json: @answer.to_json(include: :attachments) }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy])
  end

  def authorize
    unless current_user.author?(@answer)
      redirect_to question_path(@question)
      flash[:alert] = "У вас нехватает прав для выполнения этого действия."
    end
  end
end
