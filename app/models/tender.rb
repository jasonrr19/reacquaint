class Tender < ApplicationRecord
  belongs_to :user
  has_many :selected_prerequisites, dependent: :destroy
  has_many :submissions, dependent: :destroy
  validates :synopsis, presence: true
  validates :title, presence: true
  # validates :published, presence: true
end
