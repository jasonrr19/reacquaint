class CompatibleResponse < ApplicationRecord
  belongs_to :submission
  belongs_to :selected_prerequisite
  validates :notes, presence: true, length: { minimum: 50, maximum: 600 }
  validates :score, presence: true
  enum status: { accepted: 0, rejected: 0 }
end
