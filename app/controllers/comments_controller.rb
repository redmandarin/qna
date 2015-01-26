class CommentsController < ApplicationController
  include Authority

  before_action :authenticate_user!
  before_action :set_target, only: :create
  before_action :set_comment, only: [:update, :destroy, :show]
  before_action :authorize, only: [:update, :destroy]
  after_action :publish_comment, only: :create

  respond_to :js, :json

  authorize_resource

  def create
    @comment = @target.comments.create(comment_params.merge(user: current_user))
    respond_with @comment do |format|
      format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity } if @comment.invalid?
    end
  end

  def show
    respond_with @comment
  end

  def update
    @comment.update(comment_params)
    respond_with @comment do |format|
      format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity } if @comment.invalid?
    end
  end

  def destroy
    @comment.destroy
    render nothing: true
  end

  private
  
  def authorize
    unless current_user.author?(@comment)
      redirect_to questions_path
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    PrivatePub.publish_to "/questions/#{@question.id}/comments", CommentSerializer.new(@comment) if @comment.valid?
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_target
    klass = [Question, Answer].detect{ |c| params["#{c.name.underscore}_id"] }
    @target = klass.find(params["#{klass.name.underscore}_id"])
    if @target.class.name == "Question"
      @question = @target
    else
      @question = @target.question
    end
  end
end
