class Prerequisite < ApplicationRecord
  has_many :selected_prerequisite
  validates :name, presence: true
end
