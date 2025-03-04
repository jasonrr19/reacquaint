class SelectedPrerequisitesController < ApplicationController
  before_action :selected_prerequisite, only: %i[edit update rewrite analyse show]

  def edit
    authorize @selected_prerequisite
  end

  def update
    authorize @selected_prerequisite
    if @selected_prerequisite.update(selected_prerequisite_params)

      respond_to do |format|
        format.html { redirect_to tender_path(@selected_prerequisite.tender), notice: "Updated!" }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("p-bar",
            partial: 'tenders/progress_bar',
            locals: {
              tender: @selected_prerequisite.tender,
            }
          )
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def analyse
    authorize @selected_prerequisite
    openai_service = OpenaiService.new(selected_prerequisite: @selected_prerequisite)
    @selected_prerequisite.analysis = openai_service.analyse
    @selected_prerequisite.save

    respond_to do |format|
      format.html { redirect_to edit_selected_prerequisite_path(@selected_prerequisite) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("s-prereq-#{@selected_prerequisite.id}",
          partial: 'selected_prerequisites/analysis',
          locals: {
            selected_prerequisite: @selected_prerequisite,
          }
        )
      end
    end
  end

  def rewrite
    authorize @selected_prerequisite
    openai_service = OpenaiService.new(selected_prerequisite: @selected_prerequisite)
    @selected_prerequisite.description = openai_service.rewrite
    @selected_prerequisite.save

    respond_to do |format|
      format.html { redirect_to edit_selected_prerequisite_path(@selected_prerequisite) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("edit-frame-#{@selected_prerequisite.id}",
          partial: 'selected_prerequisites/edit_frame',
          locals: {
            selected_prerequisite: @selected_prerequisite,
          }
        )
      end
    end
  end

  def show
    authorize @selected_prerequisite
  end

  private

  def selected_prerequisite
    @selected_prerequisite = SelectedPrerequisite.find(params[:id])
  end

  def selected_prerequisite_params
    params.require(:selected_prerequisite).permit(:description, :prerequisite)
  end
end
