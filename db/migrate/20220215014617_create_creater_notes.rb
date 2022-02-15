class CreateCreaterNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :creater_notes do |t|
      t.text :body, null: false
      t.float :evaluation
      t.references :requester, foreign_key: { to_table: :users }
      t.boolean :requester_is_annonymous
      t.boolean :is_private, null: false, default: false
      t.timestamps
    end
  end
end
