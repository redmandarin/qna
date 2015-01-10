class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.author?(@attachment.attachmentable)
      @attachment.destroy
    end

    respond_to do |format|
      if @attachment.destroyed?
        format.json { render json: @attachment}
      else
        format.json { render json: @attachment, status: :forbidden }
      end
    end
  end
  
end
