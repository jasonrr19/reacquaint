class AddChatGptToSelectedPrerequisites < ActiveRecord::Migration[7.1]
  def change
    add_column :selected_prerequisites, :analysis, :text
    add_column :selected_prerequisites, :suggested_rewrite, :text
  end
end
