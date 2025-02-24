class CreateTenders < ActiveRecord::Migration[7.1]
  def change
    create_table :tenders do |t|
      t.text :synopsis
      t.string :title
      t.boolean :published, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
