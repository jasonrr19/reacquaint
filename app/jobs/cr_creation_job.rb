class CrCreationJob < ApplicationJob
  queue_as :default

  def perform(selected_prerequisite, submission)
    cr = CompatibleResponse.create(submission: submission, selected_prerequisite: selected_prerequisite)
    cr.score = rand(75..100)
    openai_service = OpenaiService.new(selected_prerequisite: cr.selected_prerequisite, compatible_response: cr)
    cr.notes = openai_service.write
    cr.save
    sleep(4)
    cr.notes = openai_service.cr_answer
    cr.save
    # To do: broadcast every time the CR is written by GPT
    sleep(4)
    Turbo::StreamsChannel.broadcast_replace_to(
      "tender_#{submission.tender.id}_links",
      target: "team-tab",
      partial: "selected_prerequisites/team_tab",
      locals: { compatible_response: cr }
    )
    # Update the tab content
    Turbo::StreamsChannel.broadcast_replace_to(
      "tender_#{submission.tender.id}_links",
      target: "team-tab-pane",
      partial: "selected_prerequisites/team",
      locals: { compatible_response: cr }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      "tender_#{submission.tender.id}_links",
      target: "response-tab",
      partial: "selected_prerequisites/response",
      locals: { compatible_response: cr }
    )
    # Update the response tab content
    Turbo::StreamsChannel.broadcast_replace_to(
      "tender_#{submission.tender.id}_links",
      target: "response-tab-pane",
      partial: "compatible_responses/show",
      locals: { compatible_response: cr }
    )
  end
end
