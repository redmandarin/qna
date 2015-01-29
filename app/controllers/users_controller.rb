class UsersController < ApplicationController
  before_filter :set_user, only: [:show]

  authorize_resource

  def index
    @users = User.all
  end

  def show

  end

  private

  def set_user
    @user = User.includes(:questions).find(params[:id])
  end

end