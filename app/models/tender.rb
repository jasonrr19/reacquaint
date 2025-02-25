class Tender < ApplicationRecord
  belongs_to :user
  has_many :selected_prerequisite, dependent: :destroy
  has_many :submissions, dependent: :destroy
  validates :synopsis, presence: true, length: { minimum: 100, maximum: 500 }
  validates :title, :published, presence: true
  validates :published, presence: true
end
