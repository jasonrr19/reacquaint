class CreateCompatibleEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :compatible_employees do |t|
      t.string :why_compatible
      t.references :employee, null: false, foreign_key: true
      t.references :compatible_responses, null: false, foreign_key: true

      t.timestamps
    end
  end
end
