class SelectedPrerequisitesController < ApplicationController
  before_action :selected_prerequisite, only: %i[edit update]

  def edit
    authorize @selected_prerequisite
  end

  def update
    authorize @selected_prerequisite
    if @selected_prerequisite.update(selected_prerequisite_params)
      redirect_to tender_path(@selected_prerequisite.tender), notice: "updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def selected_prerequisite
    @selected_prerequisite = SelectedPrerequisite.find(params[:id])
  end

  def selected_prerequisite_params
    params.require(:selected_prerequisite).permit(:description, :prerequisite)
  end
end
