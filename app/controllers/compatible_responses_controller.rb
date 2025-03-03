class CompatibleResponsesController < ApplicationController
  def edit
    @compatible_response = CompatibleResponse.find(params[:id])
    authorize @compatible_response
    # @compatible_response.save
  end

  def update
    @compatible_response = CompatibleResponse.find(params[:id])
    authorize @compatible_response
    if @compatible_response.update(compatible_response_params)
      redirect_to submission_path(@compatible_response.submission), notice: "updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def write
    @compatible_response = CompatibleResponse.find(params[:id])
    authorize @compatible_response
    openai_service = OpenaiService.new(selected_prerequisite: @compatible_response.selected_prerequisite, compatible_response: @compatible_response)
    @compatible_response.notes = openai_service.write
    @compatible_response.save

    respond_to do |format|
      format.html { redirect_to edit_compatible_response_path(@compatible_response) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("c-response-#{@compatible_response.id}",
          partial: 'compatible_responses/form',
          locals: {
            compatible_response: @compatible_response,
          }
        )
      end
    end
  end

  private

  def compatible_response_params
    params.require(:compatible_response).permit(:notes, :approved)
  end
end
