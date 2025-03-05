class Tender < ApplicationRecord
  belongs_to :user

  has_many :selected_prerequisites, dependent: :destroy
  accepts_nested_attributes_for :selected_prerequisites, allow_destroy: true
  has_many :submissions, dependent: :destroy
  has_many :users, through: :submissions
  validates :title, presence: true
  has_one_attached :document
  # validates :published, presence: true
  after_create_commit :create_selected_prerequisites

  include PgSearch::Model
  pg_search_scope :search_by_title_and_synopsis,
    against: [ :title, :synopsis ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

    def create_selected_prerequisites
      OpenaiService.new(tender: self).spq_read
    end

    def completed_percent
      total = selected_prerequisites.count + 1
      completed = selected_prerequisites.joins(:rich_text_description).where.not(action_text_rich_texts: { body: nil }).count
      completed += 1 if synopsis.present?
      completed.fdiv(total) * 100
    end
end
