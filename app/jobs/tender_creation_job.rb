class TenderCreationJob < ApplicationJob
  queue_as :default

  def perform(tender)
    OpenaiService.new(tender: tender).spq_read
    OpenaiService.new(tender: tender).tender_brief
  end
end
