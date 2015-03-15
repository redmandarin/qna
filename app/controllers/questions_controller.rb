class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show

  respond_to :html, :js

  authorize_resource

  def index
    if params[:tag]
      respond_with(@questions = Question.tagged_with(params[:tag]))
    else
      case params[:scope]
      when 'best_first'
        respond_with(@questions = Question.best_first)
      else
        respond_with(@questions = Question.all.includes(:answers).order(created_at: :desc))
      end
    end
  end

  def show
    @answers = @question.answers.ordered
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit

  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def build_answer
    @answer = @question.answers.build
  end

  def load_question
    @question = Question.includes([:answers, :comments, :attachments]).find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :tag_list, attachments_attributes: [:file, :_destroy])
  end
end
