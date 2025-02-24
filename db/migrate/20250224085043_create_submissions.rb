class CreateSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :submissions do |t|
      t.boolean :published, default: false
      t.boolean :shortlisted, default: false
      t.references :user, null: false, foreign_key: true
      t.references :tender, null: false, foreign_key: true

      t.timestamps
    end
  end
end
