class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :tender
  has_many :compatible_response
end
