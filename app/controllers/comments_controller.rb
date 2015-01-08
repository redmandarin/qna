class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target


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
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.json { render json: @comment }
      else
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity}
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_target
    klass = [Question, Answer].detect{ |c| params["#{c.name.underscore}_id"] }
    @target = klass.find(params["#{klass.name.underscore}_id"])
  end
end
