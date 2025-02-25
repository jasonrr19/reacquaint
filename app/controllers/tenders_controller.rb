class TendersController < ApplicationController
  def index
  end

  def show
    raise
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
