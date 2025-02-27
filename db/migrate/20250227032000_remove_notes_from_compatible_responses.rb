class RemoveNotesFromCompatibleResponses < ActiveRecord::Migration[7.1]
  def change
    remove_column :compatible_responses, :notes, :text
  end
end
