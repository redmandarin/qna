class CommentsController < ApplicationController
  include Authority

  before_action :authenticate_user!
  before_action :set_target
  before_action :set_comment, only: [:update, :destroy]
  before_action :authorize, only: [:update, :destroy]


  def create
    @comment = @target.comments.build(comment_params.merge(user: current_user))
    respond_to do |format|
      if @comment.save
        format.json { render json: @comment }
      else
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.json { render json: @comment }
      else
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @comment.destroy
    render json: { nothing: true, status: :ok }
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize
    unless current_user.author?(@comment)
      redirect_to questions_path
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_target
    klass = [Question, Answer].detect{ |c| params["#{c.name.underscore}_id"] }
    @target = klass.find(params["#{klass.name.underscore}_id"])
  end
end
