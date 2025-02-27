class CompatibleResponse < ApplicationRecord
  belongs_to :submission
  belongs_to :selected_prerequisite
  # validates :notes, presence: true, length: { minimum: 50, maximum: 600 }
  # validates :score, presence: true
  has_rich_text :notes
  has_rich_text :analysis
  has_rich_text :suggested_rewrite
end
