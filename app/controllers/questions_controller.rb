class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :authorize, only: [:edit, :update, :destroy]

  def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
      @questions = Question.all.includes(:answers).order(created_at: :desc)
    end
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit

  end

  def create
    @question = Question.new(question_params.merge(user: current_user))
    if @question.save
      redirect_to @question
      flash[:notice] = "Ваш вопрос успешно создан."
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
    flash[:notice] = "Вопрос успешно удален."
  end

  private

  def load_question
    @question = Question.find(params[:id])    
  end

  def question_params
    params.require(:question).permit(:title, :body, :tag_list)
  end

  def authorize
    unless @question.author?(current_user)
      redirect_to question_path(@question)
      flash[:alert] = "У вас нехватает прав для выполнения этого действия."
    end
  end
end
