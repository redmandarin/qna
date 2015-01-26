class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    # if current_user.author?(@attachment.attachmentable)
    #   @attachment.destroy
    # end

    respond_to do |format|
      if @attachment.destroyed?
        format.json { render json: @attachment}
      else
        format.json { render json: @attachment, status: :unauthorized }
      end
    end
  end
  
end
