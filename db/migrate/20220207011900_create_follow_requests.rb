class CreateFollowRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_requests do |t|
      t.references :user, foreign_key: true, null:false
      t.references :follow, foreign_key: { to_table: :users }, null:false

      t.timestamps
      t.index [:user_id, :follow_id], unique: true
    end
  end
end
