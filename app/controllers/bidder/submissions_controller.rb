class Bidder::SubmissionsController < ApplicationController

  def index
    @submissions = policy_scope([:bidder, Submission])
    if params[:query]
      @submissions = @submissions.search_by_title_and_synopsis(params[:query])
    end
  end
end
