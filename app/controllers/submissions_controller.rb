class SubmissionsController < ApplicationController
  def index
    @tender = Tender.find(params[:tender_id])
    @submissions = policy_scope(Submission).where(tender: @tender)
    authorize @tender
  end

  def show
    @submission = Submission.find(params[:id])
    authorize @submission
  end

  def update
  end

  def create
    @tender = Tender.find(params[:tender_id])
    @submission = Submission.new
    @submission.user = current_user
    @submission.tender = @tender
    authorize @submission
    if @submission.save
      redirect_to submission_path(@submission)
    else
      flash[:alert] = @submission.errors.full_messages.first
      render 'tenders/show', status: :unprocessable_entity
    end
  end
end
