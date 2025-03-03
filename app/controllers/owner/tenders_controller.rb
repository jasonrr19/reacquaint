class Owner::TendersController < ApplicationController
  def index
    @tenders = policy_scope([:owner, Tender])
    if params[:query].present?
      @tenders = @tenders.search_by_title_and_synopsis(params[:query])
    end
  end
end
