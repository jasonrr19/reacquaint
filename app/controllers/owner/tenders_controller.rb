class Owner::TendersController < ApplicationController
  def index
    @tenders = current_user.tenders
  end
end
