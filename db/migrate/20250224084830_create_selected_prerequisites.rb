class CreateSelectedPrerequisites < ActiveRecord::Migration[7.1]
  def change
    create_table :selected_prerequisites do |t|
      t.text :description
      t.boolean :approved, default: false
      t.references :tender, null: false, foreign_key: true
      t.references :prerequisite, null: false, foreign_key: true

      t.timestamps
    end
  end
end
