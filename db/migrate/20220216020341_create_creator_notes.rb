class CreateCreatorNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :creator_notes do |t|
      t.text :comment, null: false
      t.references :user, foreign_key: true, null: false
      t.references :requester, foreign_key: { to_table: :users }
      t.boolean :is_annonymous, default: false
      t.float :evaluation

      t.timestamps
    end
  end
end