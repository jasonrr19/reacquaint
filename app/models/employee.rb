class Employee < ApplicationRecord
  belongs_to :user
  has_many :compatible_employees
end
