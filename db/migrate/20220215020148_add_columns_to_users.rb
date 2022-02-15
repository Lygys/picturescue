class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_open_to_requests, :boolean, null: false, default: false
  end
end
