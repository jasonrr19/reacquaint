class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :tender
  has_many :compatible_response, dependent: :destroy
  validates :published, inclusion: [true, false]
  validates :published, exclusion: [nil]
  validates :shortlisted, inclusion: [true, false]
  validates :shortlisted, exclusion: [nil]
end
