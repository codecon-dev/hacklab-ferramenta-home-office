class CreateWeeklyReports < ActiveRecord::Migration[7.1]
  def change
    create_table :weekly_reports do |t|
      t.references :organization, null: false, foreign_key: true
      t.date :week_start
      t.date :week_end
      t.datetime :generated_at
      t.json :report_data

      t.timestamps
    end
  end
end
