class Tender < ApplicationRecord
  belongs_to :user
  has_many :selected_prerequisites, dependent: :destroy
  accepts_nested_attributes_for :selected_prerequisites, allow_destroy: true
  has_many :submissions, dependent: :destroy
  has_many :users, through: :submissions
  validates :synopsis, presence: true
  validates :title, presence: true
  has_many_attached :documents
  # validates :published, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_title_and_synopsis,
    against: [ :title, :synopsis ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
end
