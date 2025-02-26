class TendersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show ]
  def index
    @tender = Tender.all
  end

  def show
    @tender = Tender.find(params[:id])
    @user = User.find(params[:id])
    @prerequisite = Prerequisite.find(params[:id])
    @selected_prerequisite = @tender.selected_prerequisites
  end

  def new
    @prerequisites = Prerequisite.all
    @tender = Tender.new(params[:tender_params])
    @tender.selected_prerequisites.build # needed for nested form
  end

  def create
    @tender = Tender.new(tender_params)
    @tender.user = current_user
    if @tender.save
      redirect_to tender_path(@tender)
    else
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
