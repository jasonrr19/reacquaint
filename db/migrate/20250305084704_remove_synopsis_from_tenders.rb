class RemoveSynopsisFromTenders < ActiveRecord::Migration[7.1]
  def change
    remove_column :tenders, :synopsis, :text
  end
end
