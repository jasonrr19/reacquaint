class SynopsisCreationJob < ApplicationJob
  queue_as :default

  def perform(tender)
    OpenaiService.new(tender: tender).tender_brief
  end
end
