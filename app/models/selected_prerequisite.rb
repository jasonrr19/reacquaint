class SelectedPrerequisite < ApplicationRecord
  belongs_to :tender
  belongs_to :prerequisite
end
