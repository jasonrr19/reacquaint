class Owner::TendersController < ApplicationController
  def index
    @tenders = policy_scope([:owner, Tender])
  end
end
