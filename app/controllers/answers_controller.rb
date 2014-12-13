class AnswersController < ApplicationController
  before_filter :set_answer, only: [:edit, :update, :destroy]

  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      redirect_to question_path(params[:question_id])
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(params[:question_id])
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question_id)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :user_id, :body)
  end

end
