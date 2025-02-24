class CreatePrerequisites < ActiveRecord::Migration[7.1]
  def change
    create_table :prerequisites do |t|
      t.string :name

      t.timestamps
    end
  end
end
