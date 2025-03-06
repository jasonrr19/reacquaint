class CompatibleResponse < ApplicationRecord
  belongs_to :submission
  belongs_to :selected_prerequisite
  # validates :notes, presence: true, length: { minimum: 50, maximum: 600 }
  # validates :score, presence: true
  has_rich_text :notes
  has_rich_text :draft


  def related_responses
    selected_prerequisite.prerequisite.compatible_responses.where(submission: submission.user.submissions)
  end

end
