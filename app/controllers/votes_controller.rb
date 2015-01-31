class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target, only: [:create]
  
  respond_to :js

  authorize_resource

  def create
    @vote = @target.votes.create(vote_params.merge(user: current_user))
    @target.vote(@vote.value) if @vote.persisted?
    respond_with(@vote)
  end

  def update
    @vote = Vote.find(params[:id])
    unless @vote.value == vote_params[:value].to_i
      @vote.update(vote_params) 
      @vote.voteable.vote(@vote.value) if @vote.save
    end
    respond_with(@vote)
  end

  private

  def vote_params
    params.require(:vote).permit(:value)
  end

end