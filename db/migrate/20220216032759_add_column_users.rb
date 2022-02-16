class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :creator_note_is_private, :boolean, null: false, default: false
  end
end
