class CrCreationJob < ApplicationJob
  queue_as :default

  def perform(selected_prerequisite, submission)
    cr = CompatibleResponse.create(submission: submission, selected_prerequisite: selected_prerequisite)
    openai_service = OpenaiService.new(selected_prerequisite: cr.selected_prerequisite, compatible_response: cr)
    cr.notes = openai_service.write
    cr.save
    sleep(4)
    cr.notes = openai_service.cr_answer
    cr.save
    # To do: broadcast every time the CR is written by GPT
    sleep(4)
  end
end
