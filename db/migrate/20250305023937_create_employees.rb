class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :job_title
      t.string :job_description
      t.text :experience
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
