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
  after_create_commit :create_compatible_responses

  def create_compatible_responses
    tender.selected_prerequisites.each do |selected_prerequisite|
      CompatibleResponse.create(submission: self, selected_prerequisite: selected_prerequisite)
    end
  end

  include PgSearch::Model
  pg_search_scope :search_by_title_and_synopsis,
    associated_against: {
      tender: [ :title, :synopsis ]
    },
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

    def average_score
      return "-" if compatible_responses.empty? || compatible_responses.pluck(:score).all?(&:nil?)

      compatible_responses.pluck(:score).reject(&:nil?).sum.fdiv(compatible_responses.reject(&:nil?).count).round
    end
end
