class SelectedPrerequisite < ApplicationRecord
  belongs_to :tender
  belongs_to :prerequisite
  validates :description, presence: true, length: { minimum: 100 }
  # enum status: { approved: 0, rejected: 1 } #dont want but need boolean?
 #should require at least one prerequisite to be selectedf
end
