class RemoveDescriptionFromSelectedPrerequisites < ActiveRecord::Migration[7.1]
  def change
    remove_column :selected_prerequisites, :description, :text
    remove_column :selected_prerequisites, :analysis, :text
    remove_column :selected_prerequisites, :suggested_rewrite, :text
  end
end
