class Employee < ApplicationRecord
  belongs_to :users
  has_many :compatible_employees
end
