class CreatePostRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :post_requests do |t|
      t.references :user, foreign_key: true, null:false
      t.references :host, foreign_key: { to_table: :users }, null:false
      t.text :comment, null:false
      t.text :host_comment
      t.boolean :is_annonymous, null: false, default: false
      t.timestamps
    end
  end
end
