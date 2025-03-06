class AddWhyCompatibleToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :why_compatible, :text
  end
end
