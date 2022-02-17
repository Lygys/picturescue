class AddColumnToReport < ActiveRecord::Migration[5.2]
  def change
     add_column :reports, :is_finished, :boolean, null: false, default: false
  end
end
