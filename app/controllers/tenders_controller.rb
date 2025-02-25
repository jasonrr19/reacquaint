class TendersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show ]
  def index
    @user = User.all
  end

  def show
    @tender = Tender.find(params[:id])
    @user = User.find(params[:id])
    @prerequisite = Prerequisite.find(params[:id])
    @selected_prerequisite = @tender.selected_prerequisites
  end

  def new
  end

  def update
  end
end
