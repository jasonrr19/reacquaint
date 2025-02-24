class Tender < ApplicationRecord
  belongs_to :user
  has_many :selected_prerequisite
  has_many :submissions
end
