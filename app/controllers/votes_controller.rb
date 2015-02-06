class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target, only: [:create]
  
  respond_to :js

  authorize_resource

  def create
    @vote = @target.votes.create(vote_params.merge(user: current_user))
    respond_with(@vote)
  end

  def update
    @vote = Vote.find(params[:id])
    @vote.update(vote_params) 
    @target = @vote.voteable
    respond_with(@vote)
  end

  private

  def vote_params
    params.require(:vote).permit(:value)
  end

end