class Tender < ApplicationRecord
  belongs_to :user
  has_many :selected_prerequisite, dependent: :destroy
  has_many :submissions, dependent: :destroy
  validates :synopsis, presence: true
  validates :title, :published, presence: true
end
