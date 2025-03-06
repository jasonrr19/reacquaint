class SubmissionCreationJob < ApplicationJob
  queue_as :default

  def perform(tender)
    Submission.create!(
    tender: tender,
    user: tender.user,
    published: false,
    shortlisted: false,
  )
  end
end
