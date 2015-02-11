class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  respond_to :js

  def create
    respond_with(@subscription = Subscription.create(subscription_params.merge(user: current_user)))

  end

  private

  def subscription_params
    params.require(:subscription).permit(:question_id)
  end
end
