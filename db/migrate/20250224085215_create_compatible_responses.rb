class CreateCompatibleResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :compatible_responses do |t|
      t.text :notes
      t.boolean :approved, default: false
      t.float :score
      t.references :submission, null: false, foreign_key: true
      t.references :selected_prerequisite, null: false, foreign_key: true

      t.timestamps
    end
  end
end
