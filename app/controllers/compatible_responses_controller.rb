class CompatibleResponsesController < ApplicationController
  def edit
    @compatible_response = CompatibleResponse.find(params[:id])
    authorize @compatible_response
    @compatible_response.save
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

  private

  def compatible_response_params
    params.require(:compatible_response).permit(:notes, :approved)
  end
end
