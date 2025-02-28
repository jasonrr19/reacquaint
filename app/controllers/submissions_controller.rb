class SubmissionsController < ApplicationController
  def index
    @tender = Tender.find(params[:tender_id])
    @submissions = policy_scope(Submission).where(tender: @tender)
    authorize @tender
  end

  def show
  end

  def new
    # chris
  end

  def update
  end

  def create
  end
end
