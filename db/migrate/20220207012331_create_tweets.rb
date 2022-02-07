class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.references :user, foreign_key: true, null: false
      t.text :tweet, null: false
      t.timestamps
    end
  end
end
