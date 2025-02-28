class CompatibleResponsesController < ApplicationController
  def edit
    # @tender = Submission.tender.find(params[:tender_id)
    # @submission = Submission.find(params[:id])
    #why did it change from top to bottom?
    @compatible_response = CompatibleResponse.find(params[:id])
    @selected_prerequisites = @compatible_response.selected_prerequisite
    @submission = @compatible_response.submission
    @user = @submission.user
    authorize @compatible_response
  end

  def update
  end
end
