class AddPrerequisiteToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :prerequisite, :string
  end
end
