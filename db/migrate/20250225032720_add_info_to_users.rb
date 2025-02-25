class AddInfoToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :company_name, :string
    add_column :users, :address, :string
    add_column :users, :phone_number, :string
    add_column :users, :owner, :boolean, default: false
  end
end
