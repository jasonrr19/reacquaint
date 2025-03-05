class CompatibleEmployee < ApplicationRecord
  belongs_to :employee
  belongs_to :compatible_response
end
