class TendersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show ]
  def index
    @tenders = policy_scope(Tender)
  end

  def show
    @tender = Tender.find(params[:id])
    @selected_prerequisite = @tender.selected_prerequisites
    authorize @tender
  end

  def new
    @prerequisites = Prerequisite.all
    @tender = Tender.new(params[:tender_params])
    @tender.selected_prerequisites.build # needed for nested form
    authorize @tender
  end

  def create
    @tender = Tender.new(tender_params)
    @tender.user = current_user
    authorize @tender
    if @tender.save
      redirect_to tender_path(@tender)
    else
      raise
      render 'new', status: :unprocessable_entity
    end
  end

  def update
  end

  private

  def tender_params
    params.require(:tender).permit(:title, :synopsis, selected_prerequisites_attributes: [:prerequisite_id])
  end
end
