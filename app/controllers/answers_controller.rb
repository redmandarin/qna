class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_filter :set_answer, only: [:edit, :update]
  before_action :authorize, only: [:edit, :update]

  def new
    @question = Question.find(params[:question_id])
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      redirect_to question_path(params[:question_id])
    else
      render "new"
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(params[:question_id])
    else
      render :edit
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :user_id, :body)
  end

  def authorize
    unless @answer.author?(current_user)
      redirect_to question_path(@question)
      flash[:alert] = "У вас нехватает прав для выполнения этого действия."
    end
  end
end
