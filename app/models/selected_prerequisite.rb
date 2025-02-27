class SelectedPrerequisite < ApplicationRecord
  belongs_to :tender
  belongs_to :prerequisite
  # validates :description, presence: true, length: { minimum: 10 }
  validates :prerequisite, uniqueness: { scope: :tender }
  # enum status: { approved: 0, rejected: 1 } #dont want but need boolean?
  #should require at least one prerequisite to be selectedf
  has_rich_text :description
  has_rich_text :analysis
  has_rich_text :suggested_rewrite
end
