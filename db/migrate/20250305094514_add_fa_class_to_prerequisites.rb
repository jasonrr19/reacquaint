class AddFaClassToPrerequisites < ActiveRecord::Migration[7.1]
  def change
    add_column :prerequisites, :fa_class, :string
  end
end
