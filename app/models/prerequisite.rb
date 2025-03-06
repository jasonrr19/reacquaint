class Prerequisite < ApplicationRecord
  has_many :selected_prerequisites
  has_many :compatible_responses, through: :selected_prerequisites
end
