class Employee < ApplicationRecord
  belongs_to :user
  has_many :compatible_employees
  after_create_commit :check_compatible

  def check_compatible
    openai_service = OpenaiService.new(employee: self)
    self.why_compatible = openai_service.check_compatible
    self.save
  end
end
