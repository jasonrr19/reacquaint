class TendersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show ]
  def index
    @tenders = policy_scope(Tender)
  end

  def show
    @tender = Tender.find(params[:id])
    @selected_prerequisite = @tender.selected_prerequisites
    @submission = Submission.new
    authorize @tender
  end

  def new
    @prerequisitesicons = ["fa-solid fa-helmet-safety", "fa-solid fa-money-bill-trend-up", "fa-solid fa-star", "fa-solid fa-medal", "fa-solid fa-seedling"]
    @prerequisites = Prerequisite.all
    @tender = Tender.new(params[:tender_params])
    @tender.selected_prerequisites.build # needed for nested form
    authorize @tender
  end

  def create
    @prerequisites = Prerequisite.all
    @tender = Tender.new(tender_params)
    @tender.user = current_user
    authorize @tender
    if @tender.save
      redirect_to tender_path(@tender)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    @tender = Tender.find(params[:id])
    authorize @tender
    @tender.update(tender_params)
    redirect_to tender_path(@tender)
  end

  private

  def tender_params
    params.require(:tender).permit(:title, :synopsis, :published, selected_prerequisites_attributes: [:prerequisite_id])
  end
end
