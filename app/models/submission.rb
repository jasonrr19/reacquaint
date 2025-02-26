class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :tender
  has_many :compatible_responses, dependent: :destroy
  validates :published, inclusion: [true, false]
  validates :published, exclusion: [nil]
  validates :shortlisted, inclusion: [true, false]
  validates :shortlisted, exclusion: [nil]
  validates :tender, uniqueness: { scope: :user }
  has_many_attached :documents
end
