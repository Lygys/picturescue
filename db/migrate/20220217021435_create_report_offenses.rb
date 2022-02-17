class CreateReportOffenses < ActiveRecord::Migration[5.2]
  def change
    create_table :report_offenses do |t|
      t.references :report, foreign_key: true, null: false
      t.references :offense, foreign_key: true, null: false
      t.timestamps
    end
  end
end
