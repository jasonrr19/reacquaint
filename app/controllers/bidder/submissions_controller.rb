class Bidder::SubmissionsController < ApplicationController

  def index
    @submissions = policy_scope([:bidder, Submission])
  end
end
