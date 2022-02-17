class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.text :comment, null: false
      t.references :user, foreign_key: true, null: false
      t.references :offender, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
