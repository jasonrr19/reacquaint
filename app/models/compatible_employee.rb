class CompatibleEmployee < ApplicationRecord
  belongs_to :employees
  belongs_to :compatible_responses
end
