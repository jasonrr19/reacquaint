class AddDraftToCompatibleResponse < ActiveRecord::Migration[7.1]
  def change
    add_column :compatible_responses, :draft, :text
  end
end
