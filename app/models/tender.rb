class Tender < ApplicationRecord
  belongs_to :user
  has_many :selected_prerequisites, dependent: :destroy
  accepts_nested_attributes_for :selected_prerequisites, allow_destroy: true
  has_many :submissions, dependent: :destroy
  validates :synopsis, presence: true
  validates :title, presence: true
  # validates :published, presence: true
end
